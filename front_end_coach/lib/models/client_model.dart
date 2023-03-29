class Client {
  final String id;
  final String name;
  final String email;
  final String coachFlag;
  final String createdAt;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.coachFlag,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      createdAt: json['created_at'],
      coachFlag: json['coach_flag'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'created_at': createdAt,
    'coach_flag': coachFlag,
  };
}