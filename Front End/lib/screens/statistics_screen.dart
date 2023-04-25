import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StatisticsView extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<StatisticsView> {
  List data=[];

  Future<String> getData() async {
    var response = await http.get(Uri.parse("https://your-api-url.com/data"));
    setState(() {
      data = json.decode(response.body);
    });
    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Statistics',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Statistics'),
        ),
        body: Center(
          child: data == null
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Column(
                        children: <Widget>[
                          Text("Habits Count: ${data[index]["HabitsCount"]}"),
                          Text("Tag Percent: ${data[index]["TagPercent"]}"),
                          Text("Shortest Habit: ${data[index]["ShortestHabit"]}"),
                          Text("Longest Habit: ${data[index]["LongestHabit"]}"),
                          Text("Habits Days: "),
                          Column(
                            children: data[index]["HabitsDays"].map<Widget>((day) {
                              return Text("- ${day["end"]} : ${day["count"]} days");
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}