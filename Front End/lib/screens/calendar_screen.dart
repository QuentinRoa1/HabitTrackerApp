import 'package:flutter/material.dart';
class CalendarView extends StatefulWidget{
    @override
  _CalendarState createState() => _CalendarState();
}
class _CalendarState extends State<CalendarView> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
            title: Text('Calendar'),
            ),
        );
    }
}