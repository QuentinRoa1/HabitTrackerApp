import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:front_end_coach/providers/api_helper.dart';
import 'package:front_end_coach/util/auth_util.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _username = '';
  String _password = '';
  String _email = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          constraints: BoxConstraints.loose(const Size.square(800)),
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter your username, email and password',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  validator: AuthUtil.validateUsername,
                  onChanged: (value) {
                    _username = value;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  validator: AuthUtil.validateEmail,
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  validator: AuthUtil.validatePassword,
                  onChanged: (value) {
                    _password = value;
                  },
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data'))
                      );

                      AuthUtil auth = AuthUtil(
                        apiHelper:
                            APIHelper(url: 'http://vasycia.com/ASE485/api'),
                      );

                      auth.register(_username, _email, _password).then(
                        (registerValue) {
                          print(registerValue);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          if (registerValue) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Registered, Logging in'))
                            );
                            auth.login(_username, _password).then(
                                  (value) => {
                                    if (value)
                                      {
                                        context.go('/dashboard'),
                                      }
                                    else
                                      {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Bad Login'),
                                          ),
                                        ),
                                      }
                                  },
                                );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Invalid Username or Password')),
                            );
                          }
                        },
                      );
                    }
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
                    context.go('/login');
                  },
                  child: const Text('Sign In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
