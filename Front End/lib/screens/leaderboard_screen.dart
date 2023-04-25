import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class LeaderboardView extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<LeaderboardView> {
  List _dataList = [];

  Future<String> getData() async {
    var response = await http.get(Uri.parse('https://example.com/api/leaderboard'));
    setState(() {
      var data = json.decode(response.body);
      _dataList = data['data'];
      _dataList.sort((a, b) => b['score'].compareTo(a['score']));
    });
    return 'success';
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _dataList == null ? 0 : _dataList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_dataList[index]['name']),
              subtitle: Text(_dataList[index]['score'].toString()),
            );
          },
        ),
      ),
    );
  }
}