import 'package:flutter/material.dart';

import 'package:front_end_coach/models/task_model.dart';

class HabitsCard extends StatefulWidget {
  Task task;
  Map<String, dynamic> taskStats;

  HabitsCard(
      {required this.task, required this.taskStats});

  @override
  _HabitsCardState createState() => _HabitsCardState();
}

class _HabitsCardState extends State<HabitsCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(widget.task.getTask),
            subtitle: Text(widget.task.getTag),
          ),
        ],
      ),
    );
  }
}