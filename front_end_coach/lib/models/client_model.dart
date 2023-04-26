class Client {
  final String id;
  final String username;
  final String email;
  final String admin;
  final String createdAt;

  Client({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
    required this.admin,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      createdAt: json['created'],
      admin: json['admin'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': username,
    'email': email,
    'created_at': createdAt,
    'coach_flag': admin,
  };
}