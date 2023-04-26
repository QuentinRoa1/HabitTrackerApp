import 'package:flutter/material.dart';
import 'package:front_end_coach/util/auth_util.dart';
import 'package:go_router/go_router.dart';
import 'package:front_end_coach/screens/abstract_screen_widget.dart';

import '../../providers/http_api_helper.dart';

class LoginScreen extends AbstractScreenWidget {
  const LoginScreen({Key? key, required super.habitUtil, required super.auth});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String username = '';
  final String password = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          constraints: BoxConstraints.loose(const Size.square(500)),
          padding: const EdgeInsets.all(20),
          child: Form (
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter your Username and password',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  validator: AuthUtil.validateUsername,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  validator: AuthUtil.validatePassword,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // todo this is where auth will do its thing
                    context.go('/dashboard');
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
                    context.go('/register');
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
