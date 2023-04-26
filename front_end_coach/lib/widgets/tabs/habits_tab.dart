import 'package:flutter/material.dart';
import 'package:front_end_coach/util/habit_util.dart';

class HabitsTab extends StatefulWidget {
  final HabitUtil habitUtil;

  const HabitsTab({Key? key, required this.habitUtil}) : super(key: key);

  @override
  _HabitsTabState createState() => _HabitsTabState();
}

class _HabitsTabState extends State<HabitsTab> {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.toString()),
    );
  }
}