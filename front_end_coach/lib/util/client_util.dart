import 'package:front_end_coach/providers/placeholder_db_data.dart';
import 'package:front_end_coach/models/client_model.dart';

class ClientUtil {
  late final FakeAPI habitApiHelper;
  ClientUtil({required this.habitApiHelper});

  Future<List<Client>> getAllClients() async {
    List<String> clientIDs = await habitApiHelper.getMyClientList();
    List<Client> clientList = [];
    return Future.forEach(clientIDs, (clientID) {
      habitApiHelper.getClientDetails(clientID).then((clientDetails) =>
      clientList.add( Client.fromJson(clientDetails)));
    }).then((_) => clientList);
  }

  Future<Map<String, dynamic>> getClientStatistics(String id) {
    Map<String, dynamic> statistics = {};
    return habitApiHelper.getClientStats(id).then((value) => value[0]);
  }

  // get all clients
  // get individual client
  // create client
  // update client
  // delete client
  // get client statistics
  // get calendar client info
}