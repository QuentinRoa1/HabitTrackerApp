import 'package:flutter/material.dart';
import '../util/dbhelper.dart';
import 'package:habit_tracker/util/apicalls.dart';

class ShowForm extends StatelessWidget {
  void Function() refreshItems;
  Database db;
  late List items;

  ShowForm({required this.db, required this.refreshItems});

// TextFields' controllers
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  void updateItems(List items) {
    this.items = items;
  }

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void showForm(BuildContext ctx, int? itemKey) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item

    if (itemKey != null) {
      final existingItem =
      items.firstWhere((element) => int.parse(element['id']) == itemKey);
      _fromController.text = existingItem['start'];
      _toController.text = existingItem['end'];
      _taskController.text = existingItem['task'];
      _tagController.text = existingItem['tag'];
    }

    showModalBottomSheet(
      context: ctx,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 15,
            left: 15,
            right: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text("From:"),
            TextField(
              controller: _fromController,
              decoration: const InputDecoration(hintText: 'yyyy/mm/dd'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("To:"),
            TextField(
              controller: _toController,
              decoration: const InputDecoration(hintText: 'yyyy/mm/dd'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Task:"),
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(hintText: 'Take out garbage'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Tag:"),
            TextField(
              controller: _tagController,
              decoration: const InputDecoration(hintText: ':Housekeeping'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                // Save new item
                if (itemKey == null) {
                  sendHabit(_taskController.text.trim(),_tagController.text.trim(),_toController.text.trim(),_fromController.text.trim());
                } else {
                  updateHabit(itemKey,_taskController.text.trim(),_tagController.text.trim(),_toController.text.trim(),_fromController.text.trim());
                }
                Navigator.of(ctx).pop(); // Close the bottom sheet
              },
              child: Text(itemKey == null ? 'Create New' : 'Update'),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
