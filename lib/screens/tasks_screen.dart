import 'package:firebase_app/screens/add_task.dart';
import 'package:firebase_app/screens/login_screen.dart';
import 'package:firebase_app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return const ProfileScreen();
              }));
            },
            icon: const Icon(Icons.person),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Confirmation !'),
                    content: const Text('Are you sure to Quit the App'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (ctx) {
                            return const LoginScreen();
                          }));
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No'))
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return const AddTaskScreen();
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
