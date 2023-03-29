// ignore: depend_on_referenced_packages
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front_end_coach/errors/api_error.dart';

class APIHelper {
  late final String url;

  APIHelper({required this.url}) {
    APIHelper.testApiConnection(url).then(
      (dbAccessible) {
        if (dbAccessible) {
          url = url;
        } else {
          throw APIError('API connection failed');
        }
      },
    );
  }

  static Future<bool> testApiConnection(String apiUrl) async {
    // TODO implement actual test api endpoint
    String testUrl = '$apiUrl/auth.php?username=testing&password=testing';
    try {
      Uri uri = Uri.parse(testUrl);
      http.Response response = await http.get(uri);
      if (response.statusCode == 204) {
        // API connection successful
        return true;
      } else {
        // API connection failed
        return false;
      }
    } catch (e) {
      // API connection failed
      throw APIError('API connection failed -- $e');
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, String sessionString) async {
    String endUrl = '$url/$endpoint.php?session=$sessionString';
    try {
      http.Response response = await http.put(Uri.parse(endUrl));
      if (response.statusCode == 200) {
        // API connection successful
        return jsonDecode(response.body);
      } else {
        // API connection failed
        throw APIError('API connection failed');
      }
    } catch (e) {
      // API connection failed
      throw APIError('API connection failed -- $e.toString()');
    }
  }

  // TODO IMPLEMENT WITH BETTER STRING INTERPOLATION FOR PARAMS
  Future<Map<String, dynamic>> get(String endpoint, String username, String password) async {
    String endUrl = '$url/$endpoint.php?username=$username&password=$password';
    try {
      http.Response response = await http.get(Uri.parse(endUrl));
      if (response.statusCode == 200) {
        // API connection successful
        return jsonDecode(response.body);
      } else {
        // API connection failed
        return { "errorFlag" : response };
      }
    } catch (e) {
      // API connection failed
      throw APIError('API connection failed -- $e.toString()');
    }
  }

  Future<bool> post(String endpoint, String username, String email, String password) async {
    String endUrl = '$url/$endpoint.php?username=$username&email=$email&password=$password';
    try {
      http.Response response = await http.post(Uri.parse(endUrl));
      return (response.statusCode == 200) ? true : false;
    } catch (e) {
      // API connection failed
      throw APIError('API connection failed -- $e.toString()');
    }
  }
}
