import 'package:flutter/material.dart';

class GoalsTab extends StatefulWidget {
  const GoalsTab({Key? key}) : super(key: key);

  @override
  _GoalsTabState createState() => _GoalsTabState();
}

class _GoalsTabState extends State<GoalsTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.toString()),
    );
  }
}