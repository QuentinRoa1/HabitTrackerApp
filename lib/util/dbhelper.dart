// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Database {
  // Box<dynamic> shoppingBox;
  String db;
  late Box<dynamic> shoppingBox;
  Database({required this.db}) {
    shoppingBox = Hive.box(db);
    print(shoppingBox.keys.toList());
  }

  List<Map<String, dynamic>> toList() {
    final data = shoppingBox.keys.map((key) {
      final value = shoppingBox.get(key);
      return {
        "key": key, "date": value["date"],
        "from": value['from'], "to":value['to'],
        'task':value['task'],'tag':value['tag']
      };
    }).toList();
    return data;
  }

  // Create new item
  Future<void> createItem(Map<String, dynamic> newItem) async {
    await shoppingBox.add(newItem);
  }

  // Retrieve a single item from the database by using its key
  // Our app won't use this function but I put it here for your reference
  Map<String, dynamic> readItem(int key) {
    final item = shoppingBox.get(key);
    return item;
  }

  // Update a single item
  Future<void> updateItem(int itemKey, Map<String, dynamic> item) async {
    await shoppingBox.put(itemKey, item);
  }

  // Delete a single item
  Future<void> deleteItem(BuildContext context, int itemKey) async {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An item has been deleted')));
    await shoppingBox.delete(itemKey);
  }
}
