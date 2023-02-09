// main.dart
// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/screens/sign_in_screen.dart';
import 'package:habit_tracker/screens/sign_up_screen.dart';
import 'package:habit_tracker/screens/task_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  var tasksName = 'Tasks';
  var usersName = 'Users';

  await Hive.openBox(tasksName);
  await Hive.openBox(usersName);
  runApp(MyApp(tasksDBName: tasksName, usersDBName: usersName,));
}

class MyApp extends StatelessWidget {
  String tasksDBName;
  String usersDBName;
  MyApp({Key? key, required this.tasksDBName, required this.usersDBName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: TaskList(dbname: tasksDBName),
      routes: {
        '/sign_up_screen': (context) => SignUpScreen(signing_db_name: usersDBName),
        '/sign_in_screen': (context) => SignInScreen(signing_db_name: usersDBName),
        '/task_list_screen': (context) => TaskList(dbname: tasksDBName),
      },
    );
  }
}