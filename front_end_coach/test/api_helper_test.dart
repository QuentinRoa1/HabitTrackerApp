import 'package:front_end_coach/errors/api_error.dart';
import 'package:front_end_coach/providers/http_api_helper.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'api_helper_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late HttpApiHelper sut;
  late String validUrl;

  test('Test constructor', () async {
    validUrl = 'http://localhost:8080';
    http.Client client = http.Client();
    sut = HttpApiHelper(url: validUrl, client: client);

    expect(sut.url, validUrl);
    expect(sut.client, client);
  });

  group("test generateURI method", () {
    setUp(() {
      validUrl = 'http://localhost:8080';
      http.Client client = http.Client();
      sut = HttpApiHelper(url: validUrl, client: client);
    });

    test('Valid url and route', () async {
      String route = 'auth';
      Map<String, String>? params;
      Uri expectedUri = Uri.parse('$validUrl/$route.php');

      Uri actualUri = sut.generateURI(route, params);

      expect(actualUri, expectedUri);
    });

    test("Valid url, route and params", () async {
      String route = 'auth';
      Map<String, String>? params = {
        "username": "testing",
        "password": "testing"
      };

      String firstKey = params.keys.first;
      String secondKey = params.keys.last;
      String urlParams =
          '$firstKey=${params[firstKey]}&$secondKey=${params[secondKey]}';

      Uri expectedUri = Uri.parse('$validUrl/$route.php?$urlParams');

      Uri actualUri = sut.generateURI(route, params);

      expect(actualUri, expectedUri);
    });
  });

  group("HTTP GET Method", () {
    setUp(() {
      validUrl = 'http://localhost:8080';
      final client = MockClient();
      Map<String, http.Response> urlsToResponses = {
        '$validUrl/reqWithParams.php?username=test&password=test': http.Response('{"success": true}', 200),
        '$validUrl/reqNoParams.php': http.Response('{"success": true}', 200),
        '$validUrl/badResponse.php': http.Response('', 400)
      };

      for (String url in urlsToResponses.keys) {
        when(client.get(Uri.parse(url))).thenAnswer((_) async => urlsToResponses[url]!);
      }

      when(client.get(Uri.parse('http://localhost:8080/badRequest.php'))).thenThrow(Exception('Failed Connection Test'));

      sut = HttpApiHelper(url: validUrl, client: client);
    });

    test('Valid url, route', () async {
      String route = 'reqNoParams';
      Map<String, String>? params;
      Map<String, dynamic> response = await sut.get(route, params) as Map<String, dynamic>;

      expect(response['success'], true);
    });

    test('Valid url, route and params', () async {
      String route = 'reqWithParams';
      Map<String, String>? params = {
        "username": "test",
        "password": "test"
      };
      Map<String, dynamic> response = await sut.get(route, params) as Map<String, dynamic>;

      expect(response['success'], true);
    });

    test('Bad response', () async {
      String route = 'badResponse';
      Map<String, String>? params;

      expect(() async => await sut.get(route, params), throwsA(isA<APIError>()));
    });

    test('Bad request', () async {
      String route = 'badRequest';
      Map<String, String>? params;

      expect(() async => await sut.get(route, params), throwsA(isA<APIError>()));
    });
  });

  group("generateUrlParamString test", () {
    test("valid params", () {
      Map<String, String> params = {
        "username": "test",
        "password": "test"
      };

      String expected = "username=test&password=test";
      String actual = HttpApiHelper.generateUrlParamString(params);
      expect(actual, expected);
    });

    test("empty params", () {
      Map<String, String> params = {};

      String expected = "";
      String actual = HttpApiHelper.generateUrlParamString(params);
      expect(actual, expected);
    });

    test("whitespace in params list", () {
      Map<String, String> params = {
        "username": "test this",
        "password": "test"
      };

      expect(() => HttpApiHelper.generateUrlParamString(params), throwsA(isA<APIError>()));
    });
  });
}
