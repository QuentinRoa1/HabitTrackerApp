import 'package:flutter/material.dart';
import 'package:front_end_coach/util/goal_util.dart';

class GoalsTab extends StatefulWidget {
  final GoalUtil goalUtil;

  const GoalsTab({Key? key, required this.goalUtil}) : super(key: key);

  @override
  _GoalsTabState createState() => _GoalsTabState();
}

class _GoalsTabState extends State<GoalsTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.toString()),
    );
  }
}