// main.dart
// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/screens/sign_in_screen.dart';
import 'package:habit_tracker/screens/sign_up_screen.dart';
import 'package:habit_tracker/screens/task_list_screen.dart';
import 'package:habit_tracker/screens/calendar_screen.dart';
import 'package:habit_tracker/screens/statistics_screen.dart';
import 'package:habit_tracker/screens/leaderboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  var tasksName = 'Tasks';

  await Hive.openBox(tasksName);
  runApp(MyApp(tasksDBName: tasksName));
}

class MyApp extends StatelessWidget {
  String tasksDBName;
  MyApp({Key? key, required this.tasksDBName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: TaskList(dbname: tasksDBName),
      routes: {
        '/sign_up_screen': (context) => SignUpScreen(),
        '/sign_in_screen': (context) => SignInScreen(),
        '/task_list_screen': (context) => TaskList(dbname: tasksDBName),
        '/calendar_screen': (context) => CalendarView(),
        '/statistics_screen': (context) => StatisticsView(),
        '/leaderboard_screen': (context) => LeaderboardView(),   
      },
    );
  }
}