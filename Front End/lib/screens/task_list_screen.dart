// ignore_for_file: depend_on_referenced_packages
// TODO IMPLEMENT THIS CLASS

import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/showform.dart';
import 'package:habit_tracker/ui/cardwidget.dart';
import 'package:habit_tracker/util/dbhelper.dart';
import 'package:habit_tracker/screens/sign_in_screen.dart';
import 'package:habit_tracker/ui/searchbar.dart';

// Home Page
class TaskList extends StatefulWidget {
  String dbname;

  TaskList({Key? key, required this.dbname}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState(dbname: dbname);
}

class _TaskListState extends State<TaskList> {
  late List<Map<String, dynamic>> _items;
  final String dbname;
  late var db;
  late var show;

  _TaskListState({required this.dbname}) {
    _items = [];
    db = Database(db: dbname);
    show = ShowForm(db: db, refreshItems: _refreshItems);
  }

  @override
  void initState() {
    super.initState();
    _refreshItems(); // Load data when app starts
  }

  // Get all items from the database
  void _refreshItems() {
    final data = db.toList();
    setState(
      () {
        _items = data.reversed.toList();
        show.updateItems(_items);
        // we use "reversed" to sort items in order from the latest to the oldest
      },
    );
  }

  void deleteItem(BuildContext context, int key) {
    db.deleteItem(context, key);
    _refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASE456'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshItems(),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SignInScreen(signing_db_name: "Sign In");
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SearchInput(),
          _items.isEmpty
              ? const Center(
                  child: Text(
                    'No Data',
                    style: TextStyle(fontSize: 30),
                  ),
                )
              : ListView.builder(
                  // the list of items
                  itemCount: _items.length,
                  itemBuilder: (_, index) {
                    final currentItem = _items[index];
                    return CardWidget(currentItem, show, deleteItem);
                  },
                ),
        ],
      ),
      // Add new item button
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await show.showForm(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
