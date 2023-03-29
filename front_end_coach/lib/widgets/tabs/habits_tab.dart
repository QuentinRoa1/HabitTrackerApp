import 'package:flutter/material.dart';

class HabitsTab extends StatefulWidget {
  const HabitsTab({Key? key}) : super(key: key);

  @override
  _HabitsTabState createState() => _HabitsTabState();
}

class _HabitsTabState extends State<HabitsTab> {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.toString()),
    );
  }
}