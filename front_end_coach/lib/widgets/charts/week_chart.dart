import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class WeekChart extends StatelessWidget {
  final List<Map<String, dynamic>> values;

  const WeekChart({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    _GraphSettings settings = _GraphSettings.fromList(values);

    return SizedBox(
      height: 100,
      width: 150,
      child: SfCartesianChart(
        series: settings.series,
        primaryYAxis: settings.y,
        primaryXAxis: settings.x,
        plotAreaBorderWidth: 0,
      ),
    );
  }
}

class _GraphSettings {
  final NumericAxis x;
  final NumericAxis y;
  final List<ChartSeries> series;

  _GraphSettings({required this.x, required this.y, required this.series});

  static _GraphSettings fromList(List<Map<String, dynamic>> values) {
    NumericAxis x, y;
    List<_GraphData> data = [];
    List<LineSeries<_GraphData, int>> series = [];
    int yMax = 2;

    for (int i = 0; i < values.length; i++) {
      data.add(_GraphData(x: i, y: values[i]["count"]));
      if (values[i]["count"] > yMax) {
        yMax = values[i]["count"];
      }
    }

    double interval = (yMax / 2).round().toDouble();
    y = NumericAxis(maximum: yMax as double, interval: interval);
    x = NumericAxis(
        maximum: (values.length - 1) as double, interval: 1, isVisible: false);

    series.add(LineSeries<_GraphData, int>(
      dataSource: data,
      xValueMapper: (_GraphData data, _) => data.x,
      yValueMapper: (_GraphData data, _) => data.y,
    ));
    return _GraphSettings(x: x, y: y, series: series);
  }
}

class _GraphData {
  final int x;
  final int y;

  _GraphData({required this.x, required this.y});
}
