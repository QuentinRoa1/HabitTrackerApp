import 'package:http/http.dart' as http;
import 'package:front_end_coach/errors/api_error.dart';
import 'package:front_end_coach/providers/http_api_helper.dart';
import 'package:front_end_coach/util/cookie_util.dart';
import 'package:front_end_coach/assets/constants.dart' as constants;

class HabitApiHelper extends HttpApiHelper {
  HabitApiHelper({required super.url, required super.client});

  static Future<HabitApiHelper> create(String url, http.Client client) async {
    HabitApiHelper habitApiHelper = HabitApiHelper(url: url, client: client);

    String route = constants.authEndpoint;
    Map<String, String> testParams = {
      "username": "testing",
      "password": "testing"
    };
    int expectedResCode = 204;

    try {
      await habitApiHelper._testApiConnection(
          route, testParams, expectedResCode);
    } catch (e) {
      throw APIError('API connection failed -- ${e.toString()}');
    }

    return habitApiHelper;
  }

  Future<bool> _testApiConnection(
      String route, Map<String, String>? params, int expectedResCode) async {
    Uri uri = super.generateURI(route, params);
    try {
      // use client.get instead of super.get to set the custom statusCode
      http.Response response = await client.get(uri);
      if (response.statusCode == expectedResCode) {
        // API response incorrect
        return true;
      } else {
        // API connection successful
        throw APIError('Response incorrect -- ${response.statusCode}');
      }
    } catch (e) {
      // API connection failed
      throw APIError('Bad Request -- $e');
    }
  }

  Future<List<String>> getMyClientList() async {
    String route = constants.authEndpoint;
    String cookieString = "session";
    Future<String> cookieValue = CookieUtil.getCookie(cookieString);

    Map<String, String> params = {
      "session": await cookieValue,
    };

    Future<Iterable<dynamic>> clientList = super.put(route, params, null);
    return clientList.then((retrievedInfo) {
      dynamic clients;
      try {
        clients = retrievedInfo.first["clients"];
        List<String> clientsList = clients as List<String>;
        if (clientsList.isNotEmpty) {
          return clientsList;
        } else {
          return Future.value([]);
        }
      } catch (e) {
        throw APIError('Error retrieving clients:\n$e');
      }
    });
  }

  // from a list of clientIDs, get the client's statistics
  Future<List<Future<Iterable<dynamic>>>> getClientsInfo(
      List<String> clientIDs) async {
    String route = constants.statisticsAPIEndpoint;
    String cookieString = "session";
    String sessionString = await CookieUtil.getCookie(cookieString);
    int graphLength = 7; // TODO decouple
    Duration displayedDaysDuration = Duration(days: graphLength);
    DateTime sevenDaysAgoDateTime =
        DateTime.now().subtract(displayedDaysDuration);
    String requestDateString =
        "${sevenDaysAgoDateTime.year}-${sevenDaysAgoDateTime.month}-${sevenDaysAgoDateTime.day}";

    List<Future<Iterable<dynamic>>> clientDataList =
        clientIDs.map((e) async => await getClientStatistics(sessionString, e, requestDateString, graphLength, route)).toList();

    return clientDataList;
  }

  Future<Iterable<dynamic>> getClientStatistics(String sessionString, String e, String requestDateString, int graphLength, String route) async {
    Map<String, String> params = {
      "session": sessionString,
      "client": e,
      "date": requestDateString,
      "length": "$graphLength"
    };

    Future<Iterable<dynamic>> clientInfo = super.get(route, params);
    return clientInfo;
  }

  // from a list of clientIDs, get the client's habits
  Future<List<Future<Iterable<dynamic>>>> getClientsHabits(
      List<String> clientIDs) async {
    String route = constants.habitEndpoint;
    String cookieString = "session";
    String sessionString = await CookieUtil.getCookie(cookieString);

    List<Future<Iterable<dynamic>>> clientHabitsList =
        clientIDs.map((e) async => await getClientHabits(sessionString, e, route)).toList();

    return clientHabitsList;
  }

  Future<Iterable<dynamic>> getClientHabits(String sessionString, String client, String route) async {
    Map<String, String> params = {
      "session": sessionString,
      "client": client,
    };

    Future<Iterable<dynamic>> clientHabits = super.get(route, params);
    return clientHabits;
  }

  Future<bool> createClient(String username, String password) async {
    String route = constants.authEndpoint;
    Map<String, String> params = {
      "username": username,
      "password": password,
    };

    Future<bool> attemptedCreationFuture = super.post(route, params, null).then((value) {
      return value == "Created";
    }).catchError((error) => throw APIError('Error creating client:\n$error'));
    return attemptedCreationFuture;
  }
}
