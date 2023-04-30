import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:front_end_coach/router.dart';
import 'package:front_end_coach/providers/habit_api_helper.dart';
import 'package:front_end_coach/providers/placeholder_db_data.dart';
import 'package:front_end_coach/screens/auth/login_screen.dart';
import 'package:front_end_coach/screens/auth/register_screen.dart';
import 'package:front_end_coach/screens/loading_screen.dart';
import 'package:front_end_coach/util/client_util.dart';
import 'package:front_end_coach/util/goal_util.dart';
import 'package:front_end_coach/util/auth_util.dart';
import 'package:front_end_coach/util/habit_util.dart';

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
            FakeAPI.createFromHelper(habitHelper).then((wrappedHelper) => wrappedHelper));

    // other pages can be automated, these are just here for now
    Map<String, ScreenWidget> routerConfigMap = {
      '/login': LoginScreen.new,
      '/register': RegisterScreen.new,
    };

    Future<HabitRouter> router = apiHelper.then(setUpRouterHandler(routerConfigMap));

    return FutureBuilder(
        future: router,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            HabitRouter habitRouter = snapshot.data;
            return MaterialApp.router(
              title: 'Habit Tracker App',
              theme: ThemeData(
                primarySwatch: Colors.orange,
              ),
              routerConfig: habitRouter,
            );
          } else {
            return const MaterialApp(home: LoadingScreen(),);
          }
        });
  }

  FutureOr<String> processError(error, stackTrace) {
    if (error.toString().contains("400") || error.toString().contains("401")) {
      return Future.value('/login');
    } else {
      // todo replace with error redirect
      return Future.value('/login');
    }
  }

  FutureOr<HabitRouter> Function(FakeAPI) setUpRouterHandler(Map<String, ScreenWidget> routerConfigMap) {
    return (apiHelper) {
      AuthUtil auth = AuthUtil(habitApiHelper: apiHelper);
      HabitUtil habitUtil = HabitUtil(habitApiHelper: apiHelper);
      ClientUtil clientUtil = ClientUtil(habitApiHelper: apiHelper);
      GoalUtil goalUtil = GoalUtil(habitApiHelper: apiHelper);

      Future<bool> isLoggedIn = auth.isLoggedIn();
      Future<String> chosenRoute = isLoggedIn
          .then((isLogged) => (isLogged == true) ? '/dashboard' : '/login')
          .onError(processError);

      return chosenRoute.then((route) {
        HabitRouter habitRouter = HabitRouter.create(
            routerConfigMap: routerConfigMap,
            auth: auth,
            habitUtil: habitUtil,
            clientUtil: clientUtil,
            goalUtil: goalUtil,
            initialLocation: route);

        return habitRouter;
      });
    };
  }
}
