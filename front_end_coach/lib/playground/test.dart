// main function
import 'package:crypto/crypto.dart';
import 'dart:convert';

void main() {
  String password = "test";
  String encryptedPassword = sha256.convert(utf8.encode(password)).toString();
  print(encryptedPassword == "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08");
  print(encryptedPassword);
  print("9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08");
}