import 'package:flutter/cupertino.dart';
import 'package:front_end_coach/util/auth_util.dart';
import 'package:front_end_coach/util/habit_util.dart';

abstract class AbstractScreenWidget extends StatefulWidget {
  final HabitUtil habitUtil;
  final AuthUtil auth;

  const AbstractScreenWidget({super.key, required this.habitUtil, required this.auth});
}