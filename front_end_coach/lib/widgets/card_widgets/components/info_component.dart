import 'package:flutter/material.dart';
import 'package:front_end_coach/widgets/card_widgets/components/statistics_widget_group.dart';

class InfoComponent extends StatelessWidget {
  final String title;
  final String subtitle;
  final Map<String, String?> statsValues;
  final Widget? leading;

  const InfoComponent(
      {Key? key,
      required this.statsValues,
      required this.title,
      required this.subtitle,
      this.leading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListTile listTitle;
    if (leading != null) {
      listTitle = ListTile(
        leading: leading,
        title: Text(title),
        subtitle: Text(subtitle),
      );
    } else {
      listTitle = ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
      );
    }

    return Expanded(
      child: Column(
        children: [
          listTitle,
          StatisticsWidgetGroup(statsValues: statsValues),
        ],
      ),
    );
  }
}
