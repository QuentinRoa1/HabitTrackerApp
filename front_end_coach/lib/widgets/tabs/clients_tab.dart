import 'package:flutter/material.dart';
import 'package:front_end_coach/models/client_model.dart';
import 'package:front_end_coach/util/client_util.dart';
import 'package:front_end_coach/widgets/card_widgets/clients_card.dart';

class ClientsTab extends StatefulWidget {
  final ClientUtil clientUtil;

  const ClientsTab({Key? key, required this.clientUtil}) : super(key: key);

  @override
  _ClientsTabState createState() => _ClientsTabState();
}

class _ClientsTabState extends State<ClientsTab> {
  List<ClientsCard> _buildClientCards(List<Client> clients, Map<String, dynamic> clientStatistics) {
    List<ClientsCard> clientCards = [];
    for (Client client in clients) {
      clientCards.add(ClientsCard(
        client: client,
        clientStats: clientStatistics[client.id],
      ));
    }
    return clientCards;
  }

  List<Client> _buildClients() {
    List<Client> clients = [];
    widget.clientUtil.getAllClients().then((value) => clients = value);
    return clients;
  }
  Future<List<Map<String, dynamic>>> _buildClienStatistics(List<Client> clients) {
    List<Map<String, dynamic>> clientStatistics = [];
    return Future.forEach(clients, (client) {
      widget.clientUtil.getClientStatistics(client.id).then((value) => clientStatistics.add(value));
    }).then((_) => clientStatistics);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        children: _buildClientCards(_buildClients(), _buildClienStatistics(_buildClients()) as Map<String, dynamic>),
      ),
    );
  }
}
