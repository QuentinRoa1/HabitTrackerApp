import 'package:front_end_coach/providers/http_api_helper.dart';
import 'package:front_end_coach/util/cookie_util.dart';
import 'package:front_end_coach/assets/constants.dart' as constants;

class AuthUtil {
  late final HttpApiHelper apiHelper;

  // constructor that takes a db string and instantiates a private APIHelper object using the string
  AuthUtil({required this.apiHelper});

  Future<bool> isLoggedIn() async {
    Future<bool> sessionInCookies = AuthUtil.hasSession();
    Future<bool> isValidUser = this.isValidUser();
    Future<bool> loggedIn = Future.wait([sessionInCookies, isValidUser])
        .then((value) => value[0] && value[1]);
    return await loggedIn;
  }

  Future<bool> isValidUser() async {
    String token = await CookieUtil.getCookie("session");
    Map<String, String> params = {"session": token};
    String route = constants.authEndpoint;

    Map<String, dynamic> results = await apiHelper.put(route, params, null) as Map<String, dynamic>;
    return results.containsKey("admin") && results["admin"] == "1";
  }

  Future<String> login(String username, String password) async {
    // validate input, if valid, send to api
    if (AuthUtil.validateUsername(username) == null &&
        AuthUtil.validatePassword(password)== null) {
      Map<String, String> params = {"username": username, "password": password};
      String route = constants.authEndpoint;

      Map<String, dynamic> result = await apiHelper.get(route, params) as Map<String, dynamic>;

      if (result.containsKey("session")) {
        // save session cookie
        CookieUtil.saveCookie("session", result["session"]);
        return "Success";
      } else {
        // load login screen with error message (todo)
        return "Invalid Request";
      }
    } else {
      // display error message
      return "Invalid Username or Password";
    }
  }

  Future<dynamic> register(String username, String email, String password) async {
    // validate input, if valid, send to api
    if (AuthUtil.validateUsername(username) == null &&
        AuthUtil.validateEmail(email) == null &&
        AuthUtil.validatePassword(password) == null) {
      Map<String, String> params = {
        "username": username,
        "email": email,
        "password": password
      };
      String route = constants.authEndpoint;

      try {
        Future<Iterable<dynamic>> result = apiHelper.post(route, params, null);
        return result;
      } catch (e) {
        return Future.value("Issue with your submission: $e");
      }
    } else {
      // display error message
      return Future.value("Invalid Username or Password, please try again");
    }
  }

  static Future<bool> hasSession() async {
    Future<String> token = CookieUtil.getCookie("session");
    return token.then((value) => value != '');
  }

  static String? validateName(String? name) {
    RegExp regExp = RegExp(r'^[a-zA-Z ]+$');
    bool result = regExp.hasMatch(name??"this is invalid");

    if (!result) {
      return "Invalid Name";
    } else {
      return null;
    }
  }

  static String? validatePassword(String? pw) {
    RegExp regExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    bool result = regExp.hasMatch(pw??"this is invalid");

    if (!result) {
      return "Invalid Password";
    } else {
      return null;
    }
  }

  static String? validateUsername(String? username) {
    RegExp regExp = RegExp(r'^\w+$');
    bool result = regExp.hasMatch(username??"this is invalid");

    if (!result) {
      return "Invalid Username";
    } else {
      return null;
    }
  }

  static String? validateEmail(String? email) {
    // Define a regular expression pattern for email validation
    RegExp emailRegExp = RegExp(
      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );

    // Match the email string against the regular expression pattern
    if (!emailRegExp.hasMatch(email??"nah")) {
      // Email is invalid
      return "Please Enter a Valid Email";
    }

    // Email is valid
    return null;
  }
}
