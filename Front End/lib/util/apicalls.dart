import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:habit_tracker/util/session.dart';
Future<bool> sendHabit(String task, String tag, String start, String end) async {
    final session = await AuthPreferences.getSession();
    String taskRep = await task.replaceAll(" ", "%20");
    String startRep = await start.replaceAll("/", "-");
    String endRep = await end.replaceAll("/", "-");
    String tagRep = await tag.replaceAll(" ", "%20");
  final apiUrl = 'http://vasycia.com/ASE485/api/crud.php?session=${session}&task=${taskRep}&tag=${tag}&start=${startRep}&end=${endRep}';
  final response = await http.post(Uri.parse(apiUrl));
  if(response.statusCode != 200){
      print("Something is wrong");
      return false;
  }
  return true;
}
Future<bool> deleteHabit(var id) async {
    final session = await AuthPreferences.getSession();
  final apiUrl = 'http://vasycia.com/ASE485/api/crud.php?session=${session}&id=${id}';
  final response = await http.delete(Uri.parse(apiUrl));
  if(response.statusCode != 200){
      print("Something is wrong");
      return false;
  }
  return true;
}
Future<bool> updateHabit(var id, String task, String tag, String start, String end) async {
    final session = await AuthPreferences.getSession();
    String taskRep = await task.replaceAll(" ", "%20");
    String startRep = await start.replaceAll("/", "-");
    String endRep = await end.replaceAll("/", "-");
    String tagRep = await tag.replaceAll(" ", "%20");
  final apiUrl = 'http://vasycia.com/ASE485/api/crud.php?session=${session}&id=${id}&task=${taskRep}&tag=${tag}&start=${startRep}&end=${endRep}';
  final response = await http.put(Uri.parse(apiUrl));
  if(response.statusCode != 200){
      print("Something is wrong");
      return false;
  }
  return true;
}
Future<List> getHabits() async {
    final session = await AuthPreferences.getSession();
  final apiUrl = 'http://vasycia.com/ASE485/api/crud.php?session=${session}';
  final response = await http.get(Uri.parse(apiUrl));
  if(response.statusCode != 200){
      print("Something is wrong");
      return [];
  }
  return json.decode(response.body);
}