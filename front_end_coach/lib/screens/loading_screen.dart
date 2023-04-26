// loading screen with logo, spinner, and text

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:front_end_coach/util/svg_util.dart';
import 'package:go_router/go_router.dart';
import 'package:front_end_coach/screens/abstract_screen_widget.dart';

class LoadingScreen extends AbstractScreenWidget {
  const LoadingScreen(
      {super.key, required super.habitUtil, required super.auth});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<String> _getRoute() {
    Future<bool> isLoggedIn = widget.auth.isLoggedIn();
    Future<String> beep = isLoggedIn
        .then((value) => (value == true) ? '/dashboard' : '/login')
        .onError((error, stackTrace) {
      if (error.toString().contains("400") || error.toString().contains("401")) {
        return Future.value('/login');
      } else {
        // todo replace with error redirect
        return Future.value('/login');
      }
    });
    return beep;
  }

  String goingTo = "/";
  String message = "Loading...";

  @override
  void initState() {
    super.initState();
    _getRoute().then((value) {
      setState(() {
        goingTo = value;
        message = "Redirecting...";
      });
      context.go(goingTo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgUtil.getSvg('logoipsum-245', height: 50, width: 50),
            const SizedBox(height: 20),
            const Text("Front End Coach",
                style: TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SpinKitRing(
                  color: Colors.white,
                  size: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(message),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
