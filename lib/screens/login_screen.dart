import 'package:firebase_app/screens/signup_screen.dart';
import 'package:firebase_app/screens/tasks_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Your Email',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                var email = emailController.text.trim();
                var password = passwordController.text.trim();

                if (email.isEmpty || password.isEmpty) {
                  // show error toast
                  Fluttertoast.showToast(msg: 'Please fill all fields');

                  return;
                }

                // request to firebase auth

                ProgressDialog progressDialog = ProgressDialog(
                  context,
                  title: const Text('Signing In'),
                  message: const Text(
                    'Please wait',
                  ),
                );
                progressDialog.show();

                try {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  UserCredential userCredential =
                      await auth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  if (userCredential.user != null) {
                    progressDialog.dismiss();
                    Fluttertoast.showToast(msg: 'Successfully login');
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      return const TaskListScreen();
                    }));
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    Fluttertoast.showToast(msg: 'User not found');
                  } else if (e.code == 'wrong-password') {
                    Fluttertoast.showToast(msg: 'Wrong Password');
                  }
                  progressDialog.dismiss();
                } catch (e) {
                  Fluttertoast.showToast(msg: 'Something went wrong');
                  progressDialog.dismiss();
                }
              },
              child: const Text(
                'LogIn',
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Do not Have an account'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      return const SignUpScreen();
                    }));
                  },
                  child: const Text(
                    'SignUp Here',
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
