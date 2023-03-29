import 'dart:convert';

class Task {
  String id;
  String title;
  String creator;
  String tag;
  String startDateTime;
  String endDateTime;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.creator,
    required this.tag,
    required this.startDateTime,
    required this.endDateTime,
    required this.isDone,
  });

  factory Task.fromMap(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      creator: json['creator'],
      tag: json['tag'],
      startDateTime: json['startDateTime'],
      endDateTime: json['endDateTime'],
      isDone: json['isDone'],
    );
  }

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'creator': creator,
      'tag': tag,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'isDone': isDone,
    };
  }
}