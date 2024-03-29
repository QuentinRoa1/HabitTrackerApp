import 'dart:async';
import 'package:front_end_coach/providers/habit_api_helper.dart';
import 'package:front_end_coach/assets/constants.dart' as constants;
import 'package:front_end_coach/providers/http_api_helper.dart';
import 'package:front_end_coach/util/cookie_util.dart';
import 'package:http/http.dart' as http;

/// This class is workaround for the fact that the api is not yet complete.
/// This contains:
///  1. data that is not currently in the database schema/not accessible via the api,
///    but is needed for the app to function.
///  2. A placeholder for the api call methods that cannot be made
///    The FakeAPI gets data from the actual api, does the expected server-side processing,
///    stores some of the information (e.g. tags, habits, etc.) in memory,
///    and references it when the app needs it, returning results as if a call were made to the API
class FakeAPI extends HabitApiHelper {
  final Map<String, dynamic> clientList;
  final Map<String, dynamic> habitList;
  late final Set<String> tagList;
  final Map<String, List<String>> coachClientList = {
    "1": ["2", "3", "9"],
    "5": ["6", "7", "8"],
    "4": ["1", "2", "3", "4", "5", "6", "7", "8", "9"],
    "17": ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","18"],
  };

  FakeAPI(
      {required super.url,
      required super.client,
      required this.clientList,
      required this.habitList}) {
    tagList = Set<String>.from(habitList.values.map((e) => e["tag"] ?? ""));
  }

  static Future<FakeAPI> create(String url, http.Client client) async {
    HttpApiHelper apiHelper = HttpApiHelper(url: url, client: client);
    return await createFromHelper(apiHelper);
  }

  // factory method
  static Future<FakeAPI> createFromHelper(HttpApiHelper apiHelper) async {
    _FakeApiSetupHelper setupHelper = _FakeApiSetupHelper(apiHelper: apiHelper);
    String adminEndpoint = constants.adminEndpoint;
    String url =
        "${apiHelper.url}/$adminEndpoint.php?session=${constants.adminSessionString}";
    Uri uri = Uri.parse(url);

    return await apiHelper.client.get(uri).then((response) async {
      Map<String, dynamic> clientList =
          setupHelper.getClientListFromTableData(response);
      return setupHelper
          .getHabitDataFromClientList(clientList)
          .then((habitList) {
        return FakeAPI(
            url: apiHelper.url,
            client: apiHelper.client,
            clientList: clientList,
            habitList: habitList);
      });
    });
  }

  @override
  Future<List<String>> getMyClientList() async {
    List<String> keys = clientList.keys.toList();
    String session = constants.adminSessionString;
    if (session == constants.adminSessionString) {
      return Future.value(coachClientList["4"]);
    } else {
      String endpoint = constants.authEndpoint;
      Map<String, String> params = {
        "session": session,
      };
      return super.put(endpoint, params, null).then((value) {
        List<Map<String, dynamic>> asList =
            value.toList() as List<Map<String, dynamic>>;

        if (keys.contains(asList[0]["id"])) {
          return Future.value(coachClientList[asList[0]["id"]]);
        } else {
          try {
            // temporary workaround while handling server's get user info endpoint
            return CookieUtil.getCookie("id").then((value) => [value]);
          } catch (e) {
            return [];
          }
        }
      });
    }
  }

  @override
  Future<Map<String, dynamic>> getClientDetails(String clientID) async {
    return Future.value(clientList[clientID]);
  }

  // called for user stats endpoint
  @override
  Future<List<dynamic>> getClientStats(String userID) async {
    String endpoint = constants.statisticsAPIEndpoint;
    int length = 7;
    String startDate = DateTime.now()
        .subtract(Duration(days: length))
        .toString()
        .substring(0, 10);
    List<dynamic> clientInfo = await super
        .getClientStatistics(
            constants.adminSessionString, userID, startDate, length, endpoint)
        .then((value) => Future.value(value));
    return clientInfo;
  }

  @override
  Future<String> getHabitName(String habitId) async {
    return Future.value(habitList[habitId]["name"]);
  }

  Future<http.Response> getHabitStats(Map<String, dynamic> apiHabitList) async {
    // get the habit data
    // determine the habit stats
    // return them in a format like the userStats, but grouped by user as opposed to habit

    throw UnimplementedError();
  }

  @override
  Future<List<String>> getMyHabitList() async {
    return Future.value(habitList.keys.toList());
  }

  @override
  Future<Map<String, dynamic>> getHabitDetails(String habitID) async {
    return Future.value(habitList[habitID]);
  }

  @override
  Future<List<String>> getClientTasks(String clientId) {
    List<String> taskList = [];
    for (var habit in habitList.values) {
      if (habit["uid"] == clientId) {
        taskList.add(habit["id"]);
      }
    }
    return Future.value(taskList);
  }

  // called for tags endpoint
  Future<http.Response> getTags(bool Function(String)? clause) async {
    if (clause != null) {
      Set<String> filteredTags = tagList.where(clause).toSet();
      return Future.value(http.Response(filteredTags.toString(), 200));
    } else {
      return Future.value(http.Response(tagList.toString(), 200));
    }
  }
// called for clients endpoint
}

/// Helper class for FakeAPI
/// Contains methods for parsing the response from the admin endpoint
/// and creating the clientList and habitList
/// Also contains methods for parsing the response from the user stats endpoint
class _FakeApiSetupHelper {
  HttpApiHelper apiHelper;

  _FakeApiSetupHelper({required this.apiHelper});

  /// Calls the admin endpoint, parses the displayed html table data
  /// and returns a map of client data.
  /// * The keys are the client IDs, and the values are maps of client data
  /// * The client data maps have keys "ID", "Username", "Email", "Admin", and "Created"
  /// * The values for these keys are the corresponding values from the table
  /// ```
  /// {
  ///  "1": {
  ///    "ID": "1",
  ///    "Username": "user1",
  ///    "Email": "user1@fakeapi",
  ///    "Admin": "0",
  ///    "Created": "2021-04-01 00:00:00"
  ///  },
  /// }
  /// ```
  Map<String, dynamic> getClientListFromTableData(tableValue) {
    String responseText = tableValue.body;
    String resTable = getTableData(responseText);
    List<RegExpMatch> rowMatches = getTableRows(resTable);
    Map<String, dynamic> clientList = {};
    List<String> headers = ["ID", "Username", "Email", "Admin", "Created"];

    for (RegExpMatch rowMatch in rowMatches) {
      Map<String, String> rowInfo = getRowInfo(rowMatch, headers);
      try {
        clientList[rowInfo[headers[0]]!] = rowInfo;
      } catch (e) {
        continue;
      }
    }
    return clientList;
  }

  Future<Map<String, dynamic>> getHabitDataFromClientList(
      Map<String, dynamic> clientList) {
    List<String> clients = clientList.keys.toList();
    Map<String, String> params = {"session": constants.adminSessionString};

    return getHabitData(clients, params);
  }

  Future<Map<String, dynamic>> getHabitData(
      List<String> clients, Map<String, String> params) async {
    Map<String, dynamic> habitList = {};

    await Future.forEach(clients, (thisClient) {
      params["id"] = thisClient;
      return apiHelper.get(constants.habitEndpoint, params).then((value) {
        List<dynamic> valueList = value.toList();
        for (var val in valueList) {
          // this is the habit id, not the param id referenced above
          habitList.addAll({val["id"]: val});
        }
      });
    });
    return habitList;
  }

  String getTableData(String table) {
    RegExp tableRegEx = RegExp(r'<table(.*?)</table>');
    return tableRegEx.firstMatch(table)?.group(1) ?? "";
  }

  List<RegExpMatch> getTableRows(String table) {
    RegExp rowRegEx = RegExp(r'<tr>(.*?)</tr>');
    return rowRegEx.allMatches(table).toList();
  }

  Map<String, String> getRowInfo(RegExpMatch rowMatch, List<String> headers) {
    Map<String, String> rowInfo = {};
    String? rowString = rowMatch.group(1); // finds data b/t tr tags
    List<String> dataMatches = getDataMatches(rowString);

    if (dataMatches.isEmpty) {
      return {};
    }

    for (int i = 0; i < headers.length; i++) {
      rowInfo[headers[i]] = dataMatches[i];
    }
    return rowInfo;
  }

  List<String> getDataMatches(String? rowString) {
    RegExp idRegEx = RegExp(r'<td>(.*?)</td>');
    List<String> dataMatches = idRegEx
        .allMatches(rowString ?? "") // finds data b/t td tags
        .map((e) => e.group(1) ?? "") // converts RegExpMatch to String
        .toList(); // converts Iterable<String> to List<String>
    return dataMatches;
  }
}
