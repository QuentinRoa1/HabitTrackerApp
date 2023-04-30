import 'package:flutter/material.dart';
import 'package:front_end_coach/util/client_util.dart';
import 'package:front_end_coach/util/goal_util.dart';
import 'package:front_end_coach/widgets/tabs/clients_tab.dart';
// import 'package:front_end_coach/widgets/tabs/goals_tab.dart';
// import 'package:front_end_coach/widgets/tabs/habits_tab.dart';
import 'package:front_end_coach/screens/abstract_screen_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:front_end_coach/util/svg_util.dart';

class DashboardScreen extends AbstractScreenWidget {
  final ClientUtil clientUtil;
  final GoalUtil goalUtil;

  const DashboardScreen({Key? key, required this.clientUtil, required this.goalUtil, required super.habitUtil, required super.auth}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    widget.auth.isLoggedIn().then((isLoggedIn) {
      if (!isLoggedIn) {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'HabitTracker',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
/*        // todo re-implement tabbar
          bottom: const TabBar(
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'Clients'),
*//*            TODO: Implement Habits and Goals
              Tab(text: 'Habits'),
              Tab(text: 'Goals'),*//*
            ],
          ),*/
        ),
        body: ClientsTab(clientUtil: widget.clientUtil),
      ),
    );
  }
}
