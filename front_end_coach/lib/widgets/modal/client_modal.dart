import 'package:flutter/material.dart';
import 'package:front_end_coach/util/client_util.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:front_end_coach/models/task_model.dart';

class CalendarModal extends StatefulWidget {
  final ClientUtil clientUtil;
  final String clientId;
  const CalendarModal(
      {Key? key, required this.clientUtil, required this.clientId})
      : super(key: key);

  @override
  _CalendarModalState createState() => _CalendarModalState();
}

class _CalendarModalState extends State<CalendarModal> {
  late List<Task> _taskData;

  @override
  void initState() {
    widget.clientUtil.getClientTasks(widget.clientId).then((value) {
      setState(() => _taskData = value);
    });
    // _pieData = _getPieData(_taskData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Task> calendarData;
    try {
      calendarData = _taskData;
    } catch (e) {
      calendarData = [];
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          SfCalendar(
            view: CalendarView.month,
            dataSource: _getCalendarDataSource(calendarData ?? []),
            monthViewSettings: const MonthViewSettings(
              numberOfWeeksInView: 4,
            ),
            selectionDecoration: BoxDecoration(
              border: Border.all(color: Colors.transparent, width: 0),
            ),
          ),
        ],
      ),
    );
  }

  CalendarDataSource _getCalendarDataSource(List<Task> taskData) {
    if (taskData.isEmpty) {
      return CalendarTaskSource([]);
    }
    List<CalendarTask> meetings = taskData.map((task) {
      print(task.start);
      print(task.end);
      DateTime start = DateTime.parse(task.start);
      DateTime end = DateTime.parse(task.end);

      return CalendarTask(
          task.getTask, start, end, const Color.fromRGBO(237, 149, 122, 1));
    }).toList();
    return CalendarTaskSource(meetings);
  }
}

class CalendarTask {
  CalendarTask(this.taskName, this.from, this.to, this.background);

  String taskName;
  DateTime from;
  DateTime to;
  Color background;

  @override
  String toString() {
    return '$taskName from $from to $to';
  }
}

class CalendarTaskSource extends CalendarDataSource {
  CalendarTaskSource(List<CalendarTask> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].taskName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}
