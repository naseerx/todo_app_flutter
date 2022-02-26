import 'package:firebase_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignupScreen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(
                labelText: 'full Name',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Your Email',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              obscureText: true,
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                var fullname = fullNameController.text.trim();
                var email = emailController.text.trim();
                var password = passwordController.text.trim();
                var confirmpassword = confirmPasswordController.text.trim();

                if (fullname.isEmpty ||
                    email.isEmpty ||
                    password.isEmpty ||
                    confirmpassword.isEmpty) {
                  // show toast
                  Fluttertoast.showToast(msg: 'Please fill all fields');
                  return;
                }
                if (password.length < 6) {
                  // show toast
                  Fluttertoast.showToast(
                      msg: 'Password should be atleast 6 characters');
                  return;
                }
                if (password != confirmpassword) {
                  // show toast
                  Fluttertoast.showToast(msg: 'Password do not match');
                  return;
                }

                //request to firebase

                ProgressDialog progressDialog = ProgressDialog(
                  context,
                  title: const Text('Signing up'),
                  message: const Text(
                    'Please wait',
                  ),
                );
                progressDialog.show();

                try {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  UserCredential userCredential =
                      await auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  if (userCredential.user != null) {
                    // Store user data in relative database

                    DatabaseReference userefe =
                        FirebaseDatabase.instance.ref().child('users');
                    String? uid = userCredential.user?.uid;
                    int date = DateTime.now().millisecondsSinceEpoch;
                    await userefe.child(uid!).set({
                      'fullName': fullname,
                      'email': email,
                      'uid': uid,
                      'date': date,
                    });

                    Fluttertoast.showToast(msg: 'Success');
                  } else {
                    Fluttertoast.showToast(msg: 'Failed');
                  }
                  progressDialog.dismiss();

                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                    return const LoginScreen();
                  }));
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'email-already-in-use') {
                    Fluttertoast.showToast(msg: 'Email already use');
                    progressDialog.dismiss();
                  } else if (e.code == 'weak-password') {
                    Fluttertoast.showToast(msg: 'Password id weak');
                    progressDialog.dismiss();
                  }
                } catch (e) {
                  Fluttertoast.showToast(msg: 'Something wents wrong');
                  progressDialog.dismiss();
                }
              },
              child: const Text(
                'SignUp',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
