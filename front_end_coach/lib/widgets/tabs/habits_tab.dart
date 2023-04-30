import 'package:flutter/material.dart';
import 'package:front_end_coach/util/habit_util.dart';
import 'package:front_end_coach/widgets/card_widgets/habits_card.dart';
import 'package:front_end_coach/models/task_model.dart';


class HabitsTab extends StatefulWidget {
  final HabitUtil habitUtil;

  const HabitsTab({Key? key, required this.habitUtil}) : super(key: key);

  @override
  _HabitsTabState createState() => _HabitsTabState();
}

class _HabitsTabState extends State<HabitsTab> {
  List<Task> _habits = [];
  List<Map<String, dynamic>> _habitStatistics = [];
  List<HabitsCard> _habitCards = [];

  HabitsCard _buildClientCard(
      Task task, Map<String, dynamic> taskStats) {
    return HabitsCard(
      task: task,
      taskStats: taskStats,
    );
  }

  Future<void> _buildHabits() async {
    return widget.habitUtil.getAllHabits().then((value) =>
    _habits = value
    );
  }

  Future<void> _buildHabitStatistics() async {
    Future<void> habitStatistics = widget.habitUtil
        .getHabitStatistics(_habits)
        .then((value) =>
    _habitStatistics = value
    );
    return await habitStatistics;
  }

  @override
  void initState() {
    super.initState();
    _buildHabits().then((value) => _buildHabitStatistics().then((value) {
      for (int i = 0; i < _habits.length; i++) {
        HabitsCard habitsCard =
        _buildClientCard(_habits[i], _habitStatistics[i]);
        setState(() {
          _habitCards.add(habitsCard);
        });
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 20.0, right: 20.0),
          child: Wrap(
            spacing: 20.0,
            runSpacing: 20.0,
            children: _habitCards,
          ),
        ),
      ),
    );
  }
}