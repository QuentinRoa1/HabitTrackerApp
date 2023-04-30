import 'package:front_end_coach/errors/api_error.dart';
import 'package:front_end_coach/providers/http_api_helper.dart';
import 'package:front_end_coach/providers/habit_api_helper.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'api_helper_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group("test constructor", () {
    late final MockClient client;
    late final String validUrl, badUrl, noConnectUrl;

    setUpAll(() {
      validUrl = 'http://vasycia.com/ASE485/api/';
      badUrl = 'http://badurl.com';
      noConnectUrl = 'http://noconnect.com';
      client = MockClient();
      String route = 'auth';
      Map<String, String> params = {
        "username": "testing",
        "password": "testing"
      };

      String paramString = HttpApiHelper.generateUrlParamString(params);

      when(client.get(Uri.parse('$validUrl/$route.php?$paramString')))
          .thenAnswer((_) async => http.Response('', 204));
      when(client.get(Uri.parse('$badUrl/$route.php?$paramString')))
          .thenAnswer((_) async => http.Response('', 400));
      when(client.get(Uri.parse('$noConnectUrl/$route.php?$paramString')))
          .thenThrow(Exception('No connection'));
    });

    test('Valid url and client', () async {
      HabitApiHelper sut = HabitApiHelper(url: validUrl, client: client);

      expect(sut.url, validUrl);
      expect(sut.client, client);
    });

    test('Valid url and client through factory', () async {
      HabitApiHelper sut = await HabitApiHelper.create(validUrl, client);

      expect(sut.url, validUrl);
      expect(sut.client, client);
    });

    test('Invalid url', () async {
      // initially yields a HabitApiHelper object, but eventually emits an ApiError
      expect(() => HabitApiHelper.create(badUrl, client),
          throwsA(isA<APIError>()));
    });

    test('No connection', () async {
      expect(() => HabitApiHelper.create(noConnectUrl, client),
          throwsA(isA<APIError>()));
    });

    tearDownAll(() {
      client.close();
    });
  });
}
