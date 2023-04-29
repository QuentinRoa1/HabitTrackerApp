import 'dart:convert';

import 'package:front_end_coach/providers/http_api_helper.dart';
import 'package:front_end_coach/util/cookie_util.dart';
import 'package:front_end_coach/assets/constants.dart' as constants;
import 'package:crypto/crypto.dart';

class AuthUtil {
  late final HttpApiHelper habitApiHelper;

  // constructor that takes a db string and instantiates a private APIHelper object using the string
  AuthUtil({required this.habitApiHelper});

  Future<bool> isLoggedIn() async {
    Future<bool> sessionInCookies = AuthUtil.hasSession();
    Future<bool> isValidUser = this.isValidUser();
    Future<bool> loggedIn = Future.wait([sessionInCookies, isValidUser])
        .then((value) {
      return value[0] && value[1];
    });
    return await loggedIn;
  }

  Future<bool> isValidUser() async {
    String token = await CookieUtil.getCookie("session");
    Map<String, String> params = {"session": token};
    String route = constants.authEndpoint;

    Map<String, dynamic> results =
        await habitApiHelper.put(route, params, null).then((returnedInfo) {
          List test = returnedInfo.toList();
          try {
            return test[0] as Map<String, dynamic>;
          } catch (e) {
            if (test.isEmpty) {
              // error server side that prevents new users from logging in, this is a workaround
              return {"admin" :"1"};
            }
            return {"error": "Bad request"};
          }
        });
    return results.containsKey("admin") && results["admin"] == "1";
  }

  Future<String> login(String username, String password) async {
    // validate input, if valid, send to api
    if (AuthUtil.validateUsername(username) == null &&
        AuthUtil.validatePassword(password) == null) {
      String encryptedPassword = sha256.convert(utf8.encode(password)).toString();
      Map<String, String> params = {"username": username, "password": encryptedPassword};
      String route = constants.authEndpoint;

      Map<String, dynamic> result = await habitApiHelper
          .get(route, params)
          .then((value) => value.toList()[0] as Map<String, dynamic>).onError((error, stackTrace) {
            return { "error" : "Bad request" };
      });

      if (result.containsKey("session")) {
        // save session cookie
        await CookieUtil.saveCookie("session", result["session"]);
        await CookieUtil.saveCookie("id", result["id"]); // temp workaround until server's get user info functionality is fixed
        return "Success";
      } else {
        return "Invalid Request";
      }
    } else {
      // display error message
      return "Invalid Username or Password";
    }
  }

  Future<String> register(
      String username, String email, String password) async {
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
        Future<String> result = habitApiHelper.post(route, params, null);
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
    return token.then((value) {
      return value != '';
    });
  }

  static String? validatePassword(String? pw) {
    RegExp regExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    bool result = regExp.hasMatch(pw ?? "this is invalid");

    if (!result) {
      return "Invalid Password";
    } else {
      return null;
    }
  }

  static String? validateUsername(String? username) {
    RegExp regExp = RegExp(r'^\w+$');
    bool result = regExp.hasMatch(username ?? "this is invalid");

    if (!result) {
      return "Invalid Username";
    } else {
      return null;
    }
  }

  static String? validateEmail(String? email) {
    // Define a regular expression pattern for email validation
    RegExp emailRegExp = RegExp(
      r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );

    // Match the email string against the regular expression pattern
    if (!emailRegExp.hasMatch(email ?? "nah")) {
      // Email is invalid
      return "Please Enter a Valid Email";
    }

    // Email is valid
    return null;
  }
}
