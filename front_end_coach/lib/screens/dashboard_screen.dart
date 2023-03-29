import 'package:flutter/material.dart';
import 'package:front_end_coach/widgets/tabs/clients_tab.dart';
import 'package:front_end_coach/widgets/tabs/goals_tab.dart';
import 'package:front_end_coach/widgets/tabs/habits_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
          bottom: const TabBar(
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'Clients'),
              Tab(text: 'Habits'),
              Tab(text: 'Goals'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ClientsTab(),
            HabitsTab(),
            GoalsTab(),
          ],
        ),
      ),
    );
  }
}
