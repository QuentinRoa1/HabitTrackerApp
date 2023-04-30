import 'package:front_end_coach/providers/habit_api_helper.dart';
import 'package:front_end_coach/models/task_model.dart';

class HabitUtil {
  late final HabitApiHelper habitApiHelper;
  HabitUtil({required this.habitApiHelper});

  // get all habits
  Future<List<Task>> getAllHabits() async {
    List<String> habitIDs = await habitApiHelper.getMyHabitList();
    List<Task> habitList = [];
    return Future.forEach(habitIDs, (habitID) {
      habitApiHelper
          .getHabitDetails(habitID)
          .then((habitDetails) => habitList.add(Task.fromMap(habitDetails)));
    }).then((_) => habitList);
  }

  Future<List<Map<String, dynamic>>> getHabitStatistics(
      List<Task> habits) async {
    return [];
  }
  // get individual habit
  // create habit assigned to user
  // get habit statistics
  // get calendar habit info
}
