// ignore: depend_on_referenced_packages
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front_end_coach/errors/api_error.dart';
import 'package:front_end_coach/providers/abstract_http_api_provider.dart';

class HttpApiHelper extends AbstractHttpApiHelper {
  late final String url;
  late final http.Client client;

  HttpApiHelper({required this.url, required this.client});

  @override
  Uri generateURI(String route, Map<String, String>? params) {
    String baseUrlWithRoute = '${this.url}/$route.php';
    String urlParams = '';

    if (params != null) {
      baseUrlWithRoute += '?';
      urlParams += generateUrlParamString(params);
    }

    String url = baseUrlWithRoute + urlParams;
    Uri uri = Uri.parse(url);

    return uri;
  }

  @override
  Future<Iterable<dynamic>> get(String endpoint, Map<String, String>? params) async {
    Uri destUri = generateURI(endpoint, params);

    try {
      http.Response response = await client.get(destUri);
      if (response.statusCode == 200) {
        // API connection successful
        Iterable<dynamic> decoded = jsonDecode(response.body);
        return decoded;
      } else {
        // API connection failed
        throw APIError('Status error code: ${response.statusCode}');
      }
    } catch (e) {
      // API connection failed
      throw APIError('API req failed with params \n${params.toString()}\n${e.toString()}');
    }
  }

  @override
  Future<Iterable<dynamic>> post(String endpoint, Map<String, String>? params,
      Map<String, String>? body) async {
    Uri destUri = generateURI(endpoint, params);

    try {
      http.Response response = await client.post(destUri, body: body);
      if (response.statusCode == 200) {
        // API connection successful
        Iterable<dynamic> decoded = jsonDecode(response.body);
        return decoded;
      } else {
        // API connection failed
        throw APIError('Status error code: ${response.statusCode}');
      }
    } catch (e) {
      // API connection failed
      throw APIError('API connection failed -- ${e.toString()}');
    }
  }

  @override
  Future<Iterable<dynamic>> put(String endpoint, Map<String, String>? params,
      Map<String, String>? body) async {
    Uri destUri = generateURI(endpoint, params);

    try {
      http.Response response = await client.put(destUri, body: body);
      if (response.statusCode == 200) {
        // API connection successful
        Iterable<dynamic> decoded = jsonDecode(response.body);
        return decoded;
      } else {
        // API connection failed
        throw APIError('Status error code: ${response.statusCode}');
      }
    } catch (e) {
      // API connection failed
      throw APIError('API connection failed -- ${e.toString()}');
    }
  }

  static String generateUrlParamString(Map<String, String> params) {
    String paramString = '';

    if (params.isEmpty) {
      return paramString;
    }

    params.forEach((key, value) {
      paramString += '$key=$value&';
    });

    if (RegExp(r'\s').hasMatch(paramString)) {
      throw APIError('Invalid URL parameters');
    }

    return paramString.substring(0, paramString.length - 1);
  }
}
