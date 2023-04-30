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

  static Future<HabitApiHelper> createFromHelper(
      HttpApiHelper apiHelper) async {
    HabitApiHelper habitApiHelper =
        HabitApiHelper(url: apiHelper.url, client: apiHelper.client);

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

  Future<Map<String, dynamic>> getClientDetails(String clientID) async {
    String route = constants
        .authEndpoint; // TODO will be replaced with clients info endpoint
    String cookieString = "session";
    Future<String> cookieValue = CookieUtil.getCookie(cookieString);

    Map<String, String> params = {
      "session": await cookieValue,
      "client": clientID,
    };

    Future<Iterable<dynamic>> clientDetails = super.put(route, params, null);
    return clientDetails.then((retrievedInfo) {
      dynamic client;
      try {
        client = retrievedInfo.first;
        Map<String, dynamic> clientMap = client as Map<String, dynamic>;
        if (clientMap.isNotEmpty) {
          return clientMap;
        } else {
          return Future.value({});
        }
      } catch (e) {
        throw APIError('Error retrieving client details:\n$e');
      }
    });
  }

  Future<List<dynamic>> getClientStats(
      String userID) async {
    String route = constants.statisticsAPIEndpoint;
    String cookieString = "session";
    String sessionString = await CookieUtil.getCookie(cookieString);
    int length = 7;
    String startDate = DateTime.now().subtract(Duration(days: length)).toString().substring(0, 10);

    Future<List<dynamic>> clientInfo = getClientStatistics(sessionString, userID, startDate, length, route);
    return clientInfo;
  }

  Future<List<dynamic>> getClientStatistics(
      String sessionString,
      String clientID,
      String requestDateString,
      int graphLength,
      String route) async {
    Map<String, String> params = {
      "session": sessionString,
      "id": clientID,
      "date": requestDateString,
      "length": "$graphLength"
    };

    Future<List<dynamic>> clientInfo = super.get(route, params).then((value) {
      return value.toList();
    });
    return clientInfo;
  }

  // from a list of clientIDs, get the client's habits
  Future<List<Future<Iterable<dynamic>>>> getClientsHabits(
      List<String> clientIDs) async {
    String route = constants.habitEndpoint;
    String cookieString = "session";
    String sessionString = await CookieUtil.getCookie(cookieString);

    List<Future<Iterable<dynamic>>> clientHabitsList = clientIDs
        .map((e) async => await getClientHabits(sessionString, e, route))
        .toList();

    return clientHabitsList;
  }

  Future<Iterable<dynamic>> getClientHabits(
      String sessionString, String client, String route) async {
    Map<String, String> params = {
      "session": sessionString,
      "client": client,
    };

    Future<Iterable<dynamic>> clientHabits = super.get(route, params).then((value) {
      return value;
    });
    return clientHabits;
  }

  Future<String> getHabitName(String habitId) async {
    String endpoint = constants.statisticsPHEndpoint;
    String cookieString = "session";
    String sessionString = await CookieUtil.getCookie(cookieString);

    Map<String, String> params = {
      "session": sessionString,
      "habit": habitId,
    };

    Future<String> habitName = super.get(endpoint, params).then((value) {
      return value.first["name"];
    });
    return habitName;
  }

  // get habit ids
  Future<List<String>> getMyHabitList() async {
    String route = constants.habitEndpoint;
    String cookieString = "session";
    String sessionString = await CookieUtil.getCookie(cookieString);

    Map<String, String> params = {
      "session": sessionString,
    };

    Future<Iterable<dynamic>> habitList = super.get(route, params);
    return habitList.then((retrievedInfo) {
      dynamic habits;
      try {
        habits = retrievedInfo.first["habits"];
        List<String> habitsList = habits as List<String>;
        if (habitsList.isNotEmpty) {
          return habitsList;
        } else {
          return Future.value([]);
        }
      } catch (e) {
        throw APIError('Error retrieving habits:\n$e');
      }
    });
  }

  Future<List<String>> getClientTasks(String clientId) async {
    String route = constants.habitEndpoint;
    String cookieString = "session";
    String sessionString = await CookieUtil.getCookie(cookieString);

    Map<String, String> params = {
      "session": sessionString,
      "id": clientId,
    };

    Future<Iterable<dynamic>> habitList = super.get(route, params);
    return habitList.then((retrievedInfo) {
      dynamic habits;
      try {
        habits = retrievedInfo.first["habits"];
        List<String> habitsList = habits as List<String>;
        if (habitsList.isNotEmpty) {
          return habitsList;
        } else {
          return Future.value([]);
        }
      } catch (e) {
        throw APIError('Error retrieving habits:\n$e');
      }
    });
  }

  Future<bool> createClient(String username, String password) async {
    String route = constants.authEndpoint;
    Map<String, String> params = {
      "username": username,
      "password": password,
    };

    Future<bool> attemptedCreationFuture =
        super.post(route, params, null).then((value) {
      return value == "Created";
    }).catchError((error) => throw APIError('Error creating client:\n$error'));
    return attemptedCreationFuture;
  }

  getHabitDetails(String habitID) {}
}
