import 'package:flutter/material.dart';
import 'package:front_end_coach/models/client_model.dart';
import 'package:front_end_coach/widgets/charts/week_chart.dart';
import 'package:front_end_coach/widgets/cards/components/info_component.dart';

class ClientsCard extends StatelessWidget {
  final Client client;
  final Map<String, dynamic> clientStats;
  final Widget Function(BuildContext)? modalBuilder;

  const ClientsCard(
      {super.key,
      required this.client,
      required this.clientStats,
      this.modalBuilder});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> habits =
        clientStats["HabitsDays"] as List<Map<String, dynamic>>;

    Map<String, String?> statsValues = {
      "Shortest": clientStats["ShortestHabit"],
      "Highest": clientStats["LongestHabit"],
      "Count": clientStats["HabitsCount"].toString()
    };

    return Container(
      constraints: const BoxConstraints(maxHeight: 150, maxWidth: 500),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: modalBuilder ??
                    (context) {
                      return const Text("N/A");
                    });
          },
          child: Row(
            children: [
              InfoComponent(
                title: client.getUsername,
                subtitle: client.getEmail,
                leading: const Icon(Icons.person),
                statsValues: statsValues,
              ),
              WeekChart(values: habits),
            ],
          ),
        ),
      ),
    );
  }
}
