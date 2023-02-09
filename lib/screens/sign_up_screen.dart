// TODO IMPLEMENT SIGN UP SCREEN

import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  String signing_db_name;

  SignUpScreen({Key? key, required this.signing_db_name}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState(dbname: signing_db_name);
}

class _SignUpScreenState extends State<SignUpScreen> {
  final String dbname;

  _SignUpScreenState({required this.dbname});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign Up',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter your email and password',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Already have an account?',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, "/sign_in_screen");
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}