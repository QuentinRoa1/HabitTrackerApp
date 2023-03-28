import 'package:flutter/material.dart';
import '../util/dbhelper.dart';

class ShowForm extends StatelessWidget {
  void Function() refreshItems;
  Database db;
  late List<Map<String, dynamic>> items;

  ShowForm({required this.db, required this.refreshItems});

// TextFields' controllers
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  void updateItems(List<Map<String, dynamic>> items) {
    this.items = items;
  }

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void showForm(BuildContext ctx, int? itemKey) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item

    if (itemKey != null) {
      final existingItem =
          items.firstWhere((element) => element['key'] == itemKey);
      _dateController.text = existingItem['date'];
      _fromController.text = existingItem['from'];
      _toController.text = existingItem['to'];
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
            const Text("Date:"),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(hintText: 'yyyy/mm/dd'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Time from:"),
            TextField(
              controller: _fromController,
              decoration: const InputDecoration(hintText: '18:00'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Time to:"),
            TextField(
              controller: _toController,
              decoration: const InputDecoration(hintText: '20:00'),
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
                  if (_dateController.text == 'today') {
                    DateTime now = DateTime.now();
                    _dateController.text =
                        '${now.year}/${now.month}/${now.day}';
                  }
                  db.createItem(
                    {
                      "date": _dateController.text,
                      "from": _fromController.text,
                      "to": _toController.text,
                      "task": _taskController.text,
                      "tag": _tagController.text,
                    },
                  );
                } else {
                  db.updateItem(
                    itemKey,
                    {
                      'date': _dateController.text.trim(),
                      'from': _fromController.text.trim(),
                      'to': _toController.text.trim(),
                      'task': _taskController.text.trim(),
                      'tag': _tagController.text.trim(),
                    },
                  );
                }
                refreshItems();

                // Clear the text fields
                _dateController.text = "";
                _fromController.text = "";
                _toController.text = "";
                _taskController.text = "";
                _tagController.text = "";

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
