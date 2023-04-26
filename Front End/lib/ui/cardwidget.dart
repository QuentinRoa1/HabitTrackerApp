import 'package:flutter/material.dart';
import 'showform.dart';

class CardWidget extends StatelessWidget {
  Map<String, dynamic> currentItem;
  Function _deleteItem;
  ShowForm show;

  CardWidget(this.currentItem, this.show, this._deleteItem);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(117, 148, 157, 162),
      margin: const EdgeInsets.all(8),
      elevation: 3,
      child: ListTile(
        title: Text(currentItem['task']),
        subtitle: Text(
            '${currentItem['start']} | ${currentItem['end']} | ${currentItem['tag']}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit button
            IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async =>
                    show.showForm(context, int.parse(currentItem['id']))),
            // Delete button
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteItem(context, int.parse(currentItem['id'])),
            ),
          ],
        ),
      ),
    );
  }
}
