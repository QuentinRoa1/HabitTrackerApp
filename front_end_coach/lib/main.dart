import 'dart:async';
import 'package:flutter/material.dart';
import 'package:front_end_coach/providers/habit_api_helper.dart';
import 'package:http/http.dart' as http;
import 'package:front_end_coach/providers/placeholder_db_data.dart';
import 'package:front_end_coach/router.dart';
import 'package:front_end_coach/screens/auth/login_screen.dart';
import 'package:front_end_coach/screens/auth/register_screen.dart';
import 'package:front_end_coach/screens/dashboard_screen.dart';
import 'package:front_end_coach/screens/loading_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String url = "http://vasycia.com/ASE485/api";

    http.Client client = http.Client();
    Future<FakeAPI> apiHelper = HabitApiHelper.create(url, client).then(
            (habitHelper) =>
            FakeAPI.create(habitHelper).then((wrappedHelper) => wrappedHelper));

    Map<String, ScreenWidget> routerConfigMap = {
      '/': LoadingScreen.new,
      '/login': LoginScreen.new,
      '/register': RegisterScreen.new,
    };

    return FutureBuilder(future: apiHelper,builder:(BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
        HabitRouter habitRouter = HabitRouter.create(
            url: url,
            routerConfigMap: routerConfigMap,
            apiHelper: snapshot.data);
        return MaterialApp.router(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          routerConfig: habitRouter,
        );
      } else {
        return const CircularProgressIndicator();
      }
    });
  }
}
