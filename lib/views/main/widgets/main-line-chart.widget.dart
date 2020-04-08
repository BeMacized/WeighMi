import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weigh_mi/models/weight-entry.model.dart';
import 'package:weigh_mi/utils/weight-utils.dart';

class MainLineChart extends StatelessWidget {
  final List<WeightEntry> lineChartData;

  const MainLineChart({Key key, this.lineChartData = const []})
      : super(key: key);

  List<LineTooltipItem> getLabelsForSpot(List<LineBarSpot> spots) {
    WeightEntry entry = spots
        .map((spot) => this.lineChartData.firstWhere(
            (entry) =>
                entry.dateTime.millisecondsSinceEpoch / 1000 == spot.x &&
                entry.weight == spot.y,
            orElse: () => null))
        .firstWhere((element) => element != null);
    if (entry == null) return [];

    return [
      LineTooltipItem(
        entry.weight.toString() +
            ' ' +
            getScaleUnitName(entry.unit) +
            '\n' +
            DateFormat('HH:mm, MMMM d').format(entry.dateTime) +
            '\n' +
            DateFormat('y').format(entry.dateTime),
        TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                width: constraints.maxWidth,
                height: 100,
                padding: EdgeInsets.symmetric(vertical: 8),
                child: lineChartData.isEmpty
                    ? Container()
                    : LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: lineChartData
                                  .map((entry) => FlSpot(
                                      entry.dateTime.millisecondsSinceEpoch /
                                          1000,
                                      entry.weight))
                                  .toList(),
                              colors: [Colors.white],
                              isCurved: true,
                              dotData: FlDotData(
                                dotColor: Colors.white,
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradientColorStops: [0.0, 1.0],
                                colors: [
                                  Colors.white.withOpacity(0.8),
                                  Colors.white.withOpacity(0)
                                ],
                                gradientFrom: Offset(0, 0),
                                gradientTo: Offset(0, 1),
                              ),
                            )
                          ],
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: getLabelsForSpot,
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          titlesData: FlTitlesData(
                            show: false,
                          ),
                          gridData: FlGridData(
                            show: false,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
