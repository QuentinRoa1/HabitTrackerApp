// This contains:
//  1. data that is not currently in the database schema/not accessible via the api,
//    but is needed for the app to function.
//  2. A placeholder for the api calls that cannot be made.
//    The FakeAPI gets data from the actual api, does the expected server-side processing,
//    stores some of the information (e.g. tags, habits, etc.) in memory,
//    and references it when the app needs it, returning results as if it were the api.

// relations between clients and coaches
import 'dart:async';
import 'package:front_end_coach/providers/habit_api_helper.dart';
import 'package:front_end_coach/assets/constants.dart' as constants;
import 'package:front_end_coach/providers/http_api_helper.dart';
import 'package:http/http.dart' as http;
import 'package:front_end_coach/util/cookie_util.dart';

// wrapper that provides unimplemented API calls
class FakeAPI extends HabitApiHelper {
  final Map<String, dynamic> clientList;
  final Map<String, dynamic> habitList;
  late final Set<String> tagList;
  final Map<String, List<String>> coachClientList = {
    "1": ["2", "3", "9"],
    "5": ["6", "7", "8"],
    "4": ["1", "2", "4", "5", "6", "7", "8", "9"],
  };

  FakeAPI(
      {required super.url,
      required super.client,
      required this.clientList,
      required this.habitList}) {
    tagList = Set<String>.from(habitList.values.map((e) => e["tag"] ?? ""));
  }

  // factory method
  static Future<FakeAPI> create(HttpApiHelper apiHelper) async {
    _FakeApiSetupHelper setupHelper = _FakeApiSetupHelper(apiHelper: apiHelper);
    String adminEndpoint = constants.adminEndpoint;
    String url =
        "${apiHelper.url}/$adminEndpoint.php?session=${constants.adminSessionString}";
    Uri uri = Uri.parse(url);

    return await apiHelper.client.get(uri)
    .then((response) async {
      Map<String, dynamic> clientList = setupHelper.getClientListFromTableData(response);
      return setupHelper.getHabitDataFromClientList(clientList).then(
        (habitList) {
          return FakeAPI(
            url: apiHelper.url,
            client: apiHelper.client,
            clientList: clientList,
            habitList: habitList
          );
        }
      );
    });
  }

  @override
  Future<List<String>> getMyClientList() async {
    List<String> keys = clientList.keys.toList();
    Future<String> cookieValue = CookieUtil.getCookie("session");
    String session = await cookieValue;
    if (session == constants.adminSessionString) {
      return Future.value(coachClientList["4"]);
    } else {
      String endpoint = constants.authEndpoint;
      Map<String, String> params = {
        "session": session,
      };
      return super.put(endpoint, params, null).then((value) {
        List<Map<String, dynamic>> asList = value.toList() as List<Map<String, dynamic>>;

        if (keys.contains(asList[0]["id"])) {
          return Future.value(coachClientList[asList[0]["id"]]);
        } else {
          return [];
        }
      });
    }
  }

  Future<Map<String, dynamic>> getClientDetails(String clientID) async {
    return Future.value(clientList[clientID]);
  }

  // called for user stats endpoint
  Future<List<dynamic>> getClientStats(String userId) async {
    String endpoint = constants.statisticsAPIEndpoint;
    String date = DateTime.now().toString().substring(0, 10);
    int length = 7;
    Map<String, String> params = {
      "session": constants.adminSessionString,
      "date": date,
      "length": length.toString(),
      "id": userId
    };

    return super.get(endpoint, params).then((value) {
      List results = value.toList();
      return Future.value(results);
    });
  }

  Future<http.Response> getHabitStats(Map<String, dynamic> apiHabitList) async {
    // get the habit data
    // determine the habit stats
    // return them in a format like the userStats, but grouped by user as opposed to habit


    throw UnimplementedError();
  }

  // todo goal stats

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

class _FakeApiSetupHelper {
  HttpApiHelper apiHelper;

  _FakeApiSetupHelper({required this.apiHelper});

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

    return getHabitData(clients, params) ;
  }

  Future<Map<String, dynamic>> getHabitData(
      List<String> clients, Map<String, String> params) async {
    Map<String, dynamic> habitList = {};

    return Future.forEach(clients, (thisClient) {
      params["id"] = thisClient;
      apiHelper.get(constants.habitEndpoint, params).then((value) {
        for (var val in value) {
          // this is the habit id, not the param id referenced above
          habitList[val["id"]] = val;
        }
      });
    }).then((value) => habitList);
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
