import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _username;
  String? _email;
  String? _password;

  void _submitForm() async {
    if (_formKey.currentState?.validate()==true) {
      _formKey.currentState?.save();
      var url = Uri.parse('http://vasycia.com/ASE485/api/auth.php?username=${_username}&password=${_password}&email=${_email}');
      var response = await http.post(url);
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, '/sign_in_screen');
      } else if(response.statusCode == 400){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email or username already used'),
            duration: const Duration(seconds: 2),
          ),);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               SizedBox(
                 height:20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value?.isEmpty==true) {
                    return 'Please enter a username';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty==true) {
                    return 'Please enter an email address';
                  }
                  if (!value!.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty==true) {
                    return 'Please enter a password';
                  }
                  if (value!.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value;
                },
              ),
              SizedBox(height: 16),
              Center(
              child:
              ElevatedButton(
                child: Text('Sign up'),
                onPressed: _submitForm,
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}