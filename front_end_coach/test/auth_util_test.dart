import 'dart:async';

import 'package:front_end_coach/providers/http_api_helper.dart';
import 'package:front_end_coach/util/auth_util.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'auth_util_test.mocks.dart';

@GenerateMocks([SharedPreferences, HttpApiHelper])
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  String cookieName = 'session';
  MockHttpApiHelper mockApiHelper = MockHttpApiHelper();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('test hasSession', () async {
    expect(await AuthUtil.hasSession(), false);
    SharedPreferences.setMockInitialValues({cookieName: 'val'});
    expect(await AuthUtil.hasSession(), true);
  });

  group('Constructor tests -- ', () {
    test('Constructor', () async {
      AuthUtil authUtil = AuthUtil(habitApiHelper: mockApiHelper);
      expect(authUtil.habitApiHelper, mockApiHelper);
    });
  });

  group("Validation Methods", () {
    test("valid validateEmail", () {
      expect(AuthUtil.validateEmail("validEmail@gmail.com"), null);
    });
    test("invalid validateEmail", () {
      expect(
          AuthUtil.validateEmail("invalidEmail"), "Please Enter a Valid Email");
    });

    test("valid validatePassword", () {
      expect(AuthUtil.validatePassword("validPassword1234"), null);
    });
    test("invalid validatePassword", () {
      expect(AuthUtil.validatePassword("___________"), "Invalid Password");
    });

    test("valid validateUsername", () {
      expect(AuthUtil.validateUsername("validUN"), null);
    });
    test("invalid validateUsername", () {
      expect(AuthUtil.validateUsername("3p!cG@/\\/\\3R!!"), "Invalid Username");
    });
  });

  group("login validation tests --", () {
    late AuthUtil authUtil;

    test("Valid isValidUser test", () async {
      when(mockApiHelper.put(any, any, null)).thenAnswer((_) async {
        return Future.value({
          "admin": "1",
        } as FutureOr<Iterable>?);
      });
      authUtil = AuthUtil(habitApiHelper: mockApiHelper);
      expect(await authUtil.isValidUser(), true);
    });
    test("invalid isValidUser test", () async {
      when(mockApiHelper.put(any, any, null)).thenAnswer((_) async {
        return Future.value({
          "admin": "0",
        } as FutureOr<Iterable>?);
      });
      authUtil = AuthUtil(habitApiHelper: mockApiHelper);
      expect(await authUtil.isValidUser(), false);
    });
    test("isValidUser receives empty response test", () async {
      when(mockApiHelper.put(any, any, null)).thenAnswer((_) async {
        return Future.value([]);
      });
      authUtil = AuthUtil(habitApiHelper: mockApiHelper);
      expect(await authUtil.isValidUser(), false);
    });

    test("Valid isLoggedIn test", () async {
      SharedPreferences.setMockInitialValues({cookieName: 'val'});
      when(mockApiHelper.put(any, any, null)).thenAnswer((_) async {
        return Future.value({
          "admin": "1",
        } as FutureOr<Iterable>?);
      });
      authUtil = AuthUtil(habitApiHelper: mockApiHelper);

      expect(await authUtil.isLoggedIn(), true);
    });
    test("invalid isLoggedIn test", () async {
      SharedPreferences.setMockInitialValues({});
      when(mockApiHelper.put(any, any, null)).thenAnswer((_) async {
        return Future.value({
          "admin": "1",
        } as FutureOr<Iterable>?);
      });
      authUtil = AuthUtil(habitApiHelper: mockApiHelper);

      expect(await authUtil.isLoggedIn(), false);
    });
  });

  group("login tests --", () {
    late AuthUtil authUtil;
    Map<String, String> loginData = {
      "username": "test123",
      "password": "Testerino123",
    };

    test("Valid login test", () async {
      when(mockApiHelper.get("auth", any)).thenAnswer((_) async {
        return Future.value({
          "session": "cIsForCookie",
        } as FutureOr<Iterable>?);
      });
      authUtil = AuthUtil(habitApiHelper: mockApiHelper);

      String displayedMessage =
          await authUtil.login(loginData["username"]!, loginData["password"]!);
      expect(displayedMessage, "Success");
    });
    test("badRes login test", () async {
      when(mockApiHelper.get("auth", loginData)).thenAnswer((_) async {
        return Future.value({
          "notASession": "",
        } as FutureOr<Iterable>?);
      });
      authUtil = AuthUtil(habitApiHelper: mockApiHelper);

      String displayedMessage =
          await authUtil.login(loginData["username"]!, loginData["password"]!);
      expect(displayedMessage, "Invalid Request");
    });
    test("invalid login test", () async {
      when(mockApiHelper.get("auth", loginData)).thenAnswer((_) async {
        return Future.value({
          "session": "valid res",
        } as FutureOr<Iterable>?);
      });
      authUtil = AuthUtil(habitApiHelper: mockApiHelper);

      loginData["password"] = "p@\$\$w0rdWee";
      loginData["username"] = "oops :)";

      String displayedMessage =
          await authUtil.login(loginData["username"]!, loginData["password"]!);
      expect(
          displayedMessage, "Invalid Username or Password, please try again");
    });
  });

  group("register tests -- ", () {
    late AuthUtil authUtil;
    Map<String, String> loginData = {
      "username": "test123",
      "password": "Testerino123",
      "email": "testyBear@gmail.com"
    };

    test("Valid register test", () async {
      Map<String, dynamic> result = {
        "session": "cIsForCookie",
      };
      when(mockApiHelper.post("auth", any, null)).thenAnswer((_) async {
        return Future.value(result.toString());
      });
      authUtil = AuthUtil(habitApiHelper: mockApiHelper);
      String displayedMessage = await authUtil.register(
          loginData["username"]!, loginData["email"]!, loginData["password"]!);
      expect(displayedMessage, result.toString());
    });
    test("badRes register test", () async {
      String result = "Issue with your submission: Exception: Bad Sub";
      when(mockApiHelper.post("auth", any, null))
          .thenThrow(Exception("Bad Sub"));
      authUtil = AuthUtil(habitApiHelper: mockApiHelper);

      String displayedMessage = await authUtil.register(
          loginData["username"]!, loginData["email"]!, loginData["password"]!);
      expect(displayedMessage, result.toString());
    });
    test("badInfo register test", () async {
      String result = "Invalid Username or Password";
      authUtil = AuthUtil(habitApiHelper: mockApiHelper);

      String displayedMessage =
          await authUtil.register("b@dU\$3rN@m3", "bad email : (", "bad pw");
      expect(displayedMessage, result.toString());
    });
  });
}
