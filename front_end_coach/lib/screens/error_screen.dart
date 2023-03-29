import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  late Exception error;

  ErrorScreen({Key? key, Exception? error}) : super(key: key) {
    this.error = error ?? Exception('Unknown error');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Error',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Something went wrong, please try again later',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$this.error.toString()',
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 16,
                color: Colors.white,
                backgroundColor: Theme.of(context).primaryColorLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
