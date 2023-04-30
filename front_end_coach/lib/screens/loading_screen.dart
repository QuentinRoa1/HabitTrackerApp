// loading screen with logo, spinner, and text

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:front_end_coach/util/svg_util.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
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
              children: const [
                SpinKitRing(
                  color: Colors.white,
                  size: 50.0,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text("Loading..."),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
