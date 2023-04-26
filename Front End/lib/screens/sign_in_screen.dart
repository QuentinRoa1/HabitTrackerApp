import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:habit_tracker/util/session.dart';
class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    final String user = _userController.text.trim();
    var password = sha256.convert(utf8.encode(_passwordController.text.trim()));
    var url = Uri.parse('http://vasycia.com/ASE485/api/auth.php?username=${user}&password=${password}');

    final http.Response response = await http.get(
      url);

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final id = (responseData[0]['id']);
      final session = (responseData[0]['session']);
      AuthPreferences.saveIdAndSession(int.parse(id),session);
      Navigator.pushNamed(context, '/task_list_screen');
    } else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Username or password is incorrect'),
            duration: const Duration(seconds: 2),
          ),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _userController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              Center(child:
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Sign In'),
              ),),
              const SizedBox(height: 24.0),
              Center(child:
              ElevatedButton(
                onPressed: () {
                Navigator.pushNamed(context, '/sign_up_screen');
                },
                child: Text('Create an account'),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}