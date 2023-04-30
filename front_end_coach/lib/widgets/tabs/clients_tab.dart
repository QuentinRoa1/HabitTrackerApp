import 'package:flutter/material.dart';
import 'package:front_end_coach/models/client_model.dart';
import 'package:front_end_coach/util/client_util.dart';
import 'package:front_end_coach/widgets/card_widgets/clients_card.dart';
import 'package:front_end_coach/widgets/modal/client_modal.dart';

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
      Client client, Map<String, dynamic> clientStats) {

    return ClientsCard(
      client: client,
      clientStats: clientStats,
      modalBuilder: (context) {
        return CalendarModal(
          clientUtil: widget.clientUtil,
          clientId: client.getId,
        );
      },
    );
  }

  Future<void> _buildClients() async {
    return widget.clientUtil.getAllClients().then((value) =>
          _clients = value
        );
  }

  Future<void> _buildClientStatistics() async {
    Future<void> clientStatistics = widget.clientUtil
        .getClientsStatistics(_clients)
        .then((value) =>
              _clientStatistics = value
            );
    return await clientStatistics;
  }

  @override
  void initState() {
    super.initState();
    _buildClients().then((value) => _buildClientStatistics().then((value) {
          for (int i = 0; i < _clients.length; i++) {
            ClientsCard cliCard =
                _buildClientCard(_clients[i], _clientStatistics[i]);
            setState(() {
              _clientCards.add(cliCard);
            });
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 20.0, right: 20.0),
          child: Wrap(
            spacing: 20.0,
            runSpacing: 20.0,
            children: _clientCards,
          ),
        ),
      ),
    );
  }
}
