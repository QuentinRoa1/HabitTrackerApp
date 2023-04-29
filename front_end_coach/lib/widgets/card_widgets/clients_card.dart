import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:front_end_coach/models/client_model.dart';

class ClientsCard extends StatefulWidget {
  Client client;
  Map<String, dynamic> clientStats;

  ClientsCard({required this.client, required this.clientStats});

  @override
  _ClientsCardState createState() => _ClientsCardState();
}

class _ClientsCardState extends State<ClientsCard> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> habits = widget.clientStats["HabitsDays"] as List<Map<String, dynamic>>;
    List<int> counts = [];
    for (Map<String, dynamic> habit in habits) {
      counts.add(habit["count"]);
    }
    print(counts.toString());

    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(widget.client.getUsername),
                subtitle: Text(widget.client.getEmail),
              ),
              Container(
                height: 50,
                width: 100,
                child: SfSparkLineChart(
                  data: counts,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
