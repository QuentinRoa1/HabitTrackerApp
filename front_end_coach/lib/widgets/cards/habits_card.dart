import 'package:flutter/material.dart';
import 'package:front_end_coach/widgets/cards/components/info_component.dart';
import 'package:front_end_coach/widgets/charts/week_chart.dart';

import 'package:front_end_coach/models/task_model.dart';

class HabitsCard extends StatelessWidget {
  final Task task;
  final Map<String, dynamic> taskStats;

  const HabitsCard({super.key, required this.task, required this.taskStats});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> habits =
        taskStats["HabitsDays"] as List<Map<String, dynamic>>;

    Map<String, String?> statsValues = {
      "Average": taskStats["AverageHabit"],
    };

    return Container(
      constraints: const BoxConstraints(maxHeight: 150, maxWidth: 500),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {},
          child: Row(
            children: [
              InfoComponent(
                title: task.getTask,
                subtitle: task.getUid,
                statsValues: statsValues,
              ),
              WeekChart(values: habits),
            ],
          ),
        ),
      ),
    );
  }
}
