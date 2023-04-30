import 'package:flutter/material.dart';
import 'package:front_end_coach/providers/placeholder_db_helper.dart';
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

  HabitRouter({required super.routes, super.initialLocation});

  static HabitRouter create(
      {required Map<String, ScreenWidget> routerConfigMap,
      required AuthUtil auth,
      required HabitUtil habitUtil,
      required ClientUtil clientUtil,
      required GoalUtil goalUtil,
      String? initialLocation = "/"}) {
    List<GoRoute> routes = [];

    routerConfigMap.forEach((key, screenWidget) {
      routes.add(
        GoRoute(
          path: key,
          name: key.substring(1),
          builder: (context, state) =>
              screenWidget(habitUtil: habitUtil, auth: auth),
        ),
      );
    });

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

    return HabitRouter(routes: routes, initialLocation: initialLocation);
  }
}
