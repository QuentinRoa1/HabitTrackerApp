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
  List<Client> _clients = [];
  List<Map<String, dynamic>> _clientStatistics = [];
  List<ClientsCard> _clientCards = [];

  ClientsCard _buildClientCard(
      BuildContext context, Client client, Map<String, dynamic> clientStats) {
    return ClientsCard(
      client: client,
      clientStats: clientStats,
    );
  }

  Future<void> _buildClients() async {
    return widget.clientUtil.getAllClients().then((value) => setState(() {
          _clients = value;
        }));
  }

  Future<void> _buildClientStatistics() async {
    return Future.forEach(_clients, (client) {
      return widget.clientUtil
          .getClientStatistics(client)
          .then((value) => setState(() {
                _clientStatistics.add(value);
              }));
    });
  }

  @override
  void initState() {
    super.initState();
    _buildClients()
        .then((value) => _buildClientStatistics().then((value) => setState(() {
              print(_clientStatistics.length);
              print(_clients.length);
              for (int i = 0; i < _clients.length; i++) {
                _clientCards.add(_buildClientCard(
                    context, _clients[i], _clientStatistics[i]));
              }
            })));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
          itemCount: _clients.length,
          itemBuilder: (BuildContext context, int index) {
            try {
              return _clientCards[index];
            } catch (e) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
