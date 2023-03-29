import 'package:flutter/material.dart';
import 'package:front_end_coach/widgets/card_widgets/clients_card.dart';

class ClientsTab extends StatefulWidget {
  const ClientsTab({Key? key}) : super(key: key);

  @override
  _ClientsTabState createState() => _ClientsTabState();
}

class _ClientsTabState extends State<ClientsTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        children: const [
          ClientsCard(),
          ClientsCard(),
        ],
      ),
    );
  }
}
