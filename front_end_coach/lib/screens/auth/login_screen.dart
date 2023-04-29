import 'package:flutter/material.dart';
import 'package:front_end_coach/util/auth_util.dart';
import 'package:go_router/go_router.dart';
import 'package:front_end_coach/screens/abstract_screen_widget.dart';
import 'package:front_end_coach/util/svg_util.dart';

class LoginScreen extends AbstractScreenWidget {
  const LoginScreen({super.key, required super.habitUtil, required super.auth});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _username = '';
  String _password = '';
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgUtil.getSvg('logoipsum-245', height: 33, width: 33),
                  const SizedBox(height: 20),
                  const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Enter your Username and password',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    validator: AuthUtil.validatePassword,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    onChanged: (value) {
                      _password = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            processSubmission(context);
                          }
                        },
                        child: const Text('Sign In'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              context.go('/register');
                            },
                            child: const Text('Sign Up'),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void processSubmission(BuildContext context) {
    widget.auth.login(_username, _password).then((loginValue) {
      if (loginValue == "Success") {
        widget.auth.isLoggedIn().then((successfulLogin) {
          if (successfulLogin) {
            context.go('/dashboard');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Issue Signing in, please try again later."),
              ),
            );
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$loginValue - Please Try Again."),
          ),
        );
      }
    });
  }
}
