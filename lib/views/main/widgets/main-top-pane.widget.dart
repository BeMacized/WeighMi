import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:weigh_mi/models/menu-choice.model.dart';
import 'package:weigh_mi/models/weight-entry.model.dart';
import 'package:weigh_mi/views/main/widgets/current-weight.widget.dart';
import 'package:weigh_mi/views/main/widgets/main-line-chart.widget.dart';
import 'package:xiaomi_scale/xiaomi_scale.dart';

class MainTopPane extends StatelessWidget {
  final double currentWeight;
  final double currentBMI;
  final MiScaleUnit currentWeightUnit;
  final List<WeightEntry> lineChartData;
  final List<MenuChoice> menuChoices;

  MainTopPane({
    this.currentWeight,
    this.currentBMI,
    this.currentWeightUnit,
    this.lineChartData,
    this.menuChoices,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: MainLineChart(
                lineChartData: lineChartData,
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: CurrentWeight(
                  weight: currentWeight,
                  unit: currentWeightUnit,
                  bmi: currentBMI,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                actions: <Widget>[
                  PopupMenuButton<MenuChoice>(
                    onSelected: (choice) => choice?.onPressed(),
                    itemBuilder: (BuildContext context) {
                      return (menuChoices ?? []).map((MenuChoice choice) {
                        return PopupMenuItem<MenuChoice>(
                          value: choice,
                          child: Row(
                            children: <Widget>[
                              if (choice.icon != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Icon(
                                    choice.icon,
                                    color: Colors.black,
                                  ),
                                ),
                              Text(choice.title),
                            ],
                          ),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
