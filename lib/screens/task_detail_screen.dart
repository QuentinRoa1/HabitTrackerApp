import 'package:flutter/material.dart';

class TaskDetailScreen extends StatefulWidget {
  Map<String, dynamic> item;

  TaskDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState(item: item);
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  Map<String, dynamic> item;

  _TaskDetailScreenState({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50, bottom: 20),
              child: Text(
                '${item["task"]}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Text('${item["tag"]}'),
            Container(
              margin: const EdgeInsets.only(left: 50, right: 50),
              child: Column(
                children: [
                  Card(
                    color: Colors.blueGrey[50],
                    margin: const EdgeInsets.all(10),
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        '${item["from"]} to ${item["to"]}',
                      ),
                      trailing: Text(
                        '${item["date"]}',
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.blueGrey[50],
                    margin: const EdgeInsets.all(10),
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        '${item["from"]} to ${item["to"]}',
                      ),
                      trailing: Text(
                        '${item["date"]}',
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
