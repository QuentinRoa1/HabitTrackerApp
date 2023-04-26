abstract class AbstractHttpApiHelper {
  Future<Iterable<dynamic>> put(
      String endpoint, Map<String, String>? params, Map<String, String>? body);
  Future<Iterable<dynamic>> post(
      String endpoint, Map<String, String>? params, Map<String, String>? body);
  Future<Iterable<dynamic>> get(
      String endpoint, Map<String, String>? params);
  generateURI(String route, Map<String, String>? params);
}
