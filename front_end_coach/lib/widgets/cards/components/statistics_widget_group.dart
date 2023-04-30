import 'package:flutter/material.dart';

class _StatisticsWidget extends StatelessWidget {
  final String caption;
  final String statisticString;
  final TextStyle textStyle = const TextStyle(fontSize: 18);

  const _StatisticsWidget(
      {required this.caption, this.statisticString = "N/A"});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(caption),
      Text(statisticString, style: textStyle),
    ]);
  }
}

class StatisticsWidgetGroup extends StatelessWidget {
  final Map<String, String?> statsValues;

  const StatisticsWidgetGroup({super.key, required this.statsValues});

  List<_StatisticsWidget> _generateWidgets() {
    List<_StatisticsWidget> widgets = [];

    // print(statsValues);

    statsValues.forEach((key, value) {
      widgets.add(
          _StatisticsWidget(caption: key, statisticString: value ?? "N/A"));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _generateWidgets());
  }
}
