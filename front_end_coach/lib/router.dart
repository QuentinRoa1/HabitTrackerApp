import 'package:flutter/material.dart';
import 'package:front_end_coach/providers/placeholder_db_data.dart';
import 'package:front_end_coach/screens/dashboard_screen.dart';
import 'package:front_end_coach/util/client_util.dart';
import 'package:front_end_coach/util/goal_util.dart';
import 'package:go_router/go_router.dart';
import 'package:front_end_coach/util/auth_util.dart';
import 'package:front_end_coach/util/habit_util.dart';

typedef ScreenWidget = Widget Function(
    {required HabitUtil habitUtil, required AuthUtil auth});

class HabitRouter extends GoRouter {
  late final FakeAPI apiHelper;

  HabitRouter({required super.routes});

  static HabitRouter create(
      {required String url,
      required Map<String, ScreenWidget> routerConfigMap,
      required FakeAPI apiHelper}) {
    AuthUtil auth = AuthUtil(apiHelper: apiHelper);
    HabitUtil habitUtil = HabitUtil(habitApiHelper: apiHelper);
    List<GoRoute> routes = [];

    routerConfigMap.forEach((key, screenWidget) {
      routes.add(
        GoRoute(
          path: key,
          builder: (context, state) =>
              screenWidget(habitUtil: habitUtil, auth: auth),
        ),
      );
    });

    ClientUtil clientUtil = ClientUtil(habitApiHelper: apiHelper);
    GoalUtil goalUtil = GoalUtil(habitApiHelper: apiHelper);

    routes.add(
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => DashboardScreen(
          habitUtil: habitUtil,
          auth: auth,
          clientUtil: clientUtil,
          goalUtil: goalUtil,
        ),
      ),
    );

    return HabitRouter(routes: routes);
  }
}
