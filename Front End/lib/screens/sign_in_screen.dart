// TODO IMPLEMENT SIGN IN SCREEN
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  String signing_db_name;

  SignInScreen({Key? key, required this.signing_db_name}) : super(key: key);


  @override
  _SignInScreenState createState() => _SignInScreenState(dbname: signing_db_name);
}

class _SignInScreenState extends State<SignInScreen> {
  final String dbname;

  _SignInScreenState({required this.dbname});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign In',
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
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Don\'t have an account?',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/sign_up_screen');
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}