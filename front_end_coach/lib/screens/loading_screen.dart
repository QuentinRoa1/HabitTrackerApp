// loading screen with logo, spinner, and text

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:front_end_coach/util/auth_util.dart';
import 'package:front_end_coach/util/svg_util.dart';
import 'package:go_router/go_router.dart';

import '../providers/api_helper.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<String> getRoute() {
    AuthUtil auth = AuthUtil( apiHelper: APIHelper(url: 'http://vasycia.com/ASE485/api') );

    var isLoggedIn = auth.isLoggedIn();

    return isLoggedIn.then((value) => (value == true) ? '/dashboard' :'/login');
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
            FutureBuilder<String>(
              future: getRoute(),
              // a previously-obtained Future<String> or null
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                List<Widget> children;

                if (snapshot.connectionState == ConnectionState.done  && snapshot.hasData) {
                  children = [
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Welcome Back!'),
                    ),
                  ];
                  // redirect to the dashboard
                  context.go(snapshot.data!);
                } else if (snapshot.hasError) {
                  children = <Widget>[
                    const SpinKitRing(
                      color: Colors.white,
                      size: 50.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Redirecting...'),
                    ),
                  ];

                  // redirect to the login screen
                  context.go('/login');
                } else {
                  children = <Widget>[
                    const SpinKitRing(
                      color: Colors.white,
                      size: 50.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Loading...'),
                    ),
                  ];
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
