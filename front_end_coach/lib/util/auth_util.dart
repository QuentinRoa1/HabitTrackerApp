import 'package:front_end_coach/util/cookie_util.dart';
import 'package:front_end_coach/providers/api_helper.dart';

class AuthUtil {
  late final APIHelper apiHelper;

  // constructor that takes a db string and instantiates a private APIHelper object using the string
  AuthUtil({required this.apiHelper});

  Future<bool> isLoggedIn() async {
    Future<bool> sessionInCookies = AuthUtil.hasSession();
    Future<bool> isValidUser = this.isValidUser();

    return sessionInCookies.then((value) => isValidUser.then((value) => value));
  }

  Future<bool> isValidUser() async {
    Future<String> token = CookieUtil.getCookie("session");
    return token.then(
      (value) {
        // test that the token is valid by getting the user data
        return apiHelper
            .put("auth", value)
            .then((value) => (value['admin'] == '1') ? true : false);
      },
    );
  }

  Future<bool> login(String username, String password) async {
    // validate input, if valid, send to api
    if (AuthUtil.validateUsername(username) == '' &&
        AuthUtil.validatePassword(password)== '') {
      Map<String, dynamic> result = await apiHelper.get("auth", username, password);

      if (result.containsKey("session")) {
        // save session cookie
        CookieUtil.saveCookie("session", result["session"]);
        return true;
      } else {
        // load login screen with error message (todo)
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    // validate input, if valid, send to api
    if (AuthUtil.validateUsername(username) == null &&
        AuthUtil.validateEmail(email) == null &&
        AuthUtil.validatePassword(password) == null) {
      return apiHelper.post("auth", username, email, password);
    } else {
      return Future.value(false);
    }
  }

  static Future<bool> hasSession() async {
    Future<String> token = CookieUtil.getCookie("session");
    return token.then((value) => value != '');
  }

  static String? validatePassword(String? pw) {
    //TODO determine password requirements
    return null;
  }

  static String? validateUsername(String? username) {
    //TODO determine username requirements
    return null;
  }

  static String? validateEmail(String? email) {
    // Define a regular expression pattern for email validation
    RegExp emailRegExp = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
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
