import 'package:flutter/material.dart';

class ClientsCard extends StatefulWidget {
  const ClientsCard({Key? key}) : super(key: key);

  @override
  _ClientsCardState createState() => _ClientsCardState();
}

class _ClientsCardState extends State<ClientsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Client Name'),
            subtitle: Text('Client Email'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('Edit'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {},
                child: const Text('Delete'),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}