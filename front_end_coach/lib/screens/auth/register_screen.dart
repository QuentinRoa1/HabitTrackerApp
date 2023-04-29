import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:front_end_coach/util/auth_util.dart';
import 'package:front_end_coach/screens/abstract_screen_widget.dart';
import 'package:front_end_coach/util/svg_util.dart';

class RegisterScreen extends AbstractScreenWidget {
  const RegisterScreen(
      {super.key, required super.habitUtil, required super.auth});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _username = '';
  String _password = '';
  String _confirmPassword = '';
  String _email = '';
  final _formKey = GlobalKey<FormState>();

  String? _validator(String? input) {
    if (input == _password && _confirmPassword == _password) {
      return null;
    } else {
      return "Passwords do not match.";
    }
  }

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
                const SizedBox(height: 10),
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter your username, email and password',
                  style: TextStyle(fontSize: 16),
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
                    labelText: 'Email',
                  ),
                  validator: AuthUtil.validateEmail,
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                  ),
                  validator: _validator,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  onChanged: (value) {
                    _confirmPassword = value;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          processInput(context);
                        } // no else, validate will show error messages
                      },
                      child: const Text('Sign Up'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Already have an account?  ',
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/login');
                          },
                          child: const Text(
                            'Sign In',
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void processInput(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Processing Data...')));

    widget.auth.register(_username, _email, _password).then(
      (registerValue) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        if (registerValue == "Created") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Registered, please login to continue.')));
          // wait 2 seconds before going to login screen
          Future.delayed(const Duration(seconds: 2), () {
            context.go('/login');
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid Username or Password')),
          );
        }
      },
    );
  }
}
