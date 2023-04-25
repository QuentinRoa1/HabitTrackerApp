import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferences {
  static const String _idKey = 'id';
  static const String _sessionKey = 'session';

  static Future<void> saveIdAndSession(int id, String session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_idKey, id);
    await prefs.setString(_sessionKey, session);
  }

  static Future<String?> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_idKey);
  }

  static Future<String?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_idKey);
    await prefs.remove(_sessionKey);
  }
}
