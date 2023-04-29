import 'package:front_end_coach/util/auth_util.dart';

class Client {
  final String _id;
  final String _username;
  final String _email;
  final String _admin;
  final String _createdAt;

  Client({
    required String id,
    required String username,
    required String email,
    required String createdAt,
    required String admin,
  }) : _createdAt = createdAt, _admin = admin, _email = email, _username = username, _id = id;

  factory Client.fromMap(Map<String, dynamic> json) {
    return Client(
      id: json['ID'],
      username: json['Username'],
      email: json['Email'],
      createdAt: json['Created'],
      admin: json['Admin'],
    );
  }

  Map<String, dynamic> toMap() => {
    'id': _id,
    'name': _username,
    'email': _email,
    'created_at': _createdAt,
    'coach_flag': _admin,
  };

  // getters
  String get getId => _id;
  String get getUsername => _username;
  String get getEmail => _email;
  String get getCreatedAt => _createdAt;
  String get getAdmin => _admin;

  // setters -- only for the client-side, validation and changing server-side data is handled by HabitAPIHelpers.
  set setUsername(String username) {
    if (AuthUtil.validateUsername(username) == null) {
      username = username;
    } else {
      throw Exception("Invalid Username");
    }
  }
  set setEmail(String email) {
    if (AuthUtil.validateEmail(email) == null) {
      email = email;
    } else {
      throw Exception("Invalid Email");
    }
  }

  set setCreatedAt(String createdAt) {
    DateTime current = DateTime.parse(_createdAt);
    DateTime? newDate = DateTime.tryParse(createdAt);

    if (newDate != null && newDate.isAfter(current)) {
      createdAt = createdAt;
    } else {
      throw Exception("Invalid Date");
    }
  }
}