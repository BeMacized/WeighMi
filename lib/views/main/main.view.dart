import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weigh_mi/models/menu-choice.model.dart';
import 'package:weigh_mi/models/stat-data.model.dart';
import 'package:weigh_mi/models/weight-entry.model.dart';
import 'package:weigh_mi/views/main/widgets/ble-error-bar.widget.dart';
import 'package:weigh_mi/views/main/widgets/main-last-entries-pane.widget.dart';
import 'package:weigh_mi/views/main/widgets/main-stats-pane.widget.dart';
import 'package:weigh_mi/views/main/widgets/main-top-pane.widget.dart';

import 'main-view.provider.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  MainViewProvider vp;

  @override
  void initState() {
    vp = Provider.of<MainViewProvider>(context, listen: false);
    vp.onViewInit();
    super.initState();
  }

  @override
  void dispose() {
    vp.onViewDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  StreamBuilder<Map>(
                      stream: Rx.combineLatest4(
                          vp.currentWeight,
                          vp.weightUnit,
                          vp.currentBMI,
                          vp.lineChartData,
                          (currentWeight, weightUnit, currentBMI, lineChartData) => {
                                'currentWeight': currentWeight,
                                'weightUnit': weightUnit,
                                'currentBMI': currentBMI,
                                'lineChartData': lineChartData
                              }),
                      initialData: {},
                      builder: (context, snapshot) {
                        return MainTopPane(
                          currentWeight: snapshot.data['currentWeight'],
                          currentWeightUnit: snapshot.data['currentWeightUnit'],
                          currentBMI: snapshot.data['currentBMI'],
                          lineChartData: snapshot.data['lineChartData'],
                          menuChoices: [
                            MenuChoice(
                              icon: Icons.note_add,
                              title: 'Import from Libra',
                              onPressed: () => vp.libraImport(),
                            ),
                            MenuChoice(
                              icon: Icons.delete,
                              title: 'Delete All Measurements',
                              onPressed: () => vp.deleteAllMeasurements(context),
                            ),
                          ],
                        );
                      }),
                  BLEErrorBar(),
                  StreamBuilder<List<StatData>>(
                    stream: vp.statDatas,
                    initialData: [],
                    builder: (context, snapshot) {
                      return Padding(
                        padding: EdgeInsets.only(left: 12, right: 12, top: 12),
                        child: MainStatsPane(stats: snapshot.data),
                      );
                    },
                  ),
                  StreamBuilder<List<WeightEntry>>(
                    stream: vp.lastWeightEntries,
                    initialData: [],
                    builder: (context, snapshot) {
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: MainLastEntriesPane(
                          weightEntries: snapshot.data,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
