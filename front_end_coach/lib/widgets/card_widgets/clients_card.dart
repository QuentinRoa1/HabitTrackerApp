import 'package:flutter/material.dart';

import 'package:front_end_coach/models/client_model.dart';

class ClientsCard extends StatefulWidget {
  Client client;
  Map<String, dynamic> clientStats;

  ClientsCard(
      {required this.client, required this.clientStats});

  @override
  _ClientsCardState createState() => _ClientsCardState();
}

class _ClientsCardState extends State<ClientsCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(widget.client.username),
            subtitle: Text(widget.client.email),
          ),
        ],
      ),
    );
  }
}