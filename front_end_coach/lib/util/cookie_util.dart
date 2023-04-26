import 'package:shared_preferences/shared_preferences.dart';

class CookieUtil {
  static Future<void> saveCookie(String cookieName, String cookieValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(cookieName, cookieValue);
  }

  static Future<String> getCookie(String cookieName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cookieString = prefs.getString(cookieName);
    if (cookieString != null) {
      return cookieString;
    } else {
      return '';
    }
  }

  static Future<void> deleteCookie(String cookieName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(cookieName);
  }
}