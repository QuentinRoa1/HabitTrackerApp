import 'package:front_end_coach/providers/placeholder_db_data.dart';
import 'package:front_end_coach/models/client_model.dart';

class ClientUtil {
  late final FakeAPI habitApiHelper;

  ClientUtil({required this.habitApiHelper});

  Future<List<Client>> getAllClients() async {
    List<String> clientIDs = await habitApiHelper.getMyClientList();
    List<Client> clientList = [];
    return Future.forEach(clientIDs, (clientID) {
      habitApiHelper.getClientDetails(clientID).then(
          (clientDetails) => clientList.add(Client.fromMap(clientDetails)));
    }).then((_) => clientList);
  }

  Future<Client> getClient(String clientID) async {
    Map<String, dynamic> clientDetails =
        await habitApiHelper.getClientDetails(clientID);
    return Client.fromMap(clientDetails);
  }

  Future<Map<String, dynamic>> getClientStatistics(Client client) async {
    Future<Map<String, dynamic>> statistics =
        habitApiHelper.getClientStats(client.getId).then((value) {
          try {
            Map<String, dynamic> clientStats = value[0];
            clientStats["HabitsDays"] = fillHabitsDaysList(clientStats);
            return clientStats;
          } catch (e) {
            return {};
          }
        });
    return statistics;
  }

  List<Map<String, dynamic>> fillHabitsDaysList(Map<String, dynamic> clientStats) {
    List<Map<String, dynamic>> habitsDaysList = [];
    int length = 7;
    DateTime startDate = DateTime.now().subtract(Duration(days: length));
    for (int i = 0; i < length; i++) {
      DateTime date = startDate.add(const Duration(days: 1));
      String dateString = date.toString().substring(0, 10);
      int count = 0;

      for (int j = 0; j < clientStats["HabitsDays"].length; j++) {
        if (clientStats["HabitsDays"][j]["end"] == "$dateString 00:00:00") {
          count = int.parse(clientStats["HabitsDays"][j]["count"]);
          break;
        }
      }

      habitsDaysList.add({"date": dateString, "count": count});

      startDate = date;
    }
    return habitsDaysList;
  }

// create client
  Future<bool> createClient(String username, String email, String password) async {
    bool clientCreated =
        await habitApiHelper.createClient(username, email);
    return clientCreated;
  }

// update client
// delete client
// get calendar client info
}
