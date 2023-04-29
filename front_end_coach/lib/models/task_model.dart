import 'dart:convert';

class Task {
  String id;
  String task;
  String uid;
  String tag;
  String start;
  String end;

  Task({
    required this.id,
    required this.task,
    required this.uid,
    required this.tag,
    required this.start,
    required this.end,
  });

  factory Task.fromMap(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      uid: json['uid'],
      task: json['task'],
      tag: json['tag'],
      start: json['start'],
      end: json['end'],
    );
  }

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'uid': uid,
      'tag': tag,
      'start': start,
      'end': end,
    };
  }

  // getters
  String get getId => id;

  String get getTask => task;

  String get getUid => uid;

  String get getTag => tag;

  String get getStart => start;

  String get getEnd => end;

  // setters -- only for the client-side, validation and changing server-side data is handled by HabitAPIHelpers.
  set setTask(String task) => task = task;

  set setTag(String tag) => tag = tag;

  set setStart(String start) => start = start;

  set setEnd(String end) => end = end;
}
