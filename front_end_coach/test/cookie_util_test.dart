import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front_end_coach/util/cookie_util.dart';

import 'cookie_util_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  String cookieName = 'testCookie';
  SharedPreferences prefs = MockSharedPreferences();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('test saveCookie -- ', () {
    test('saveCookie', () async {
      when(prefs.setString(cookieName, 'newValue'))
          .thenAnswer((_) async => true);
      await CookieUtil.saveCookie(cookieName, 'newValue');

      expect(await CookieUtil.getCookie(cookieName), 'newValue');
    });

    test('saveCookie fails', () async {
      SharedPreferences prefs = MockSharedPreferences();
      when(prefs.setString(cookieName, 'newValue'))
          .thenAnswer((_) async => false);
      await CookieUtil.saveCookie(cookieName, 'newValue');
      expect(await CookieUtil.getCookie(cookieName), 'newValue');
    });
  });

  group('test getCookie -- ', () {
    test('getCookie', () async {
      SharedPreferences.setMockInitialValues({cookieName: 'testValue'});
      SharedPreferences prefs = MockSharedPreferences();
      when(prefs.getString(cookieName)).thenAnswer((_) => 'testValue');
      String cookie = await CookieUtil.getCookie(cookieName);
      expect(cookie, 'testValue');
    });

    test('getCookie fails', () async {
      SharedPreferences prefs = MockSharedPreferences();
      when(prefs.getString(cookieName)).thenAnswer((_) => null);
      String cookie = await CookieUtil.getCookie(cookieName);
      expect(cookie, '');
    });
  });

  group('test deleteCookie -- ', () {
    test('deleteCookie', () async {
      SharedPreferences.setMockInitialValues({cookieName: 'testValue'});
      SharedPreferences prefs = MockSharedPreferences();

      when(prefs.remove(cookieName)).thenAnswer((_) async => true);
      await CookieUtil.deleteCookie(cookieName);
      expect(await CookieUtil.getCookie(cookieName), '');
    });
  });
}
