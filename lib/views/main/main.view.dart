import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:weigh_mi/models/menu-choice.model.dart';
import 'package:weigh_mi/views/main/widgets/main-last-entries-pane.widget.dart';
import 'package:weigh_mi/views/main/widgets/main-stats-pane.widget.dart';
import 'package:weigh_mi/views/main/widgets/main-top-pane.widget.dart';

import 'main-view.provider.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  void initState() {
    super.initState();
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
                  Consumer<MainViewProvider>(builder: (context, vp, child) {
                    return MainTopPane(
                      currentWeight: vp.currentWeight,
                      currentWeightUnit: vp.currentWeightUnit,
                      currentBMI: vp.currentBMI,
                      lineChartData: vp.lineChartData,
                      menuChoices: [
                        MenuChoice(
                          icon: Icons.note_add,
                          title: 'Import from Libra',
                          onPressed: vp.onLibraImport,
                        ),
                        MenuChoice(
                          icon: Icons.delete,
                          title: 'Delete All Measurements',
                          onPressed: () => vp.onDeleteAllMeasurements(context),
                        ),
                      ],
                    );
                  }),
                  Consumer<MainViewProvider>(builder: (context, vp, child) {
                    return Padding(
                      padding: EdgeInsets.only(left: 12, right: 12, top: 12),
                      child: MainStatsPane(stats: vp.statDatas),
                    );
                  }),
                  Consumer<MainViewProvider>(builder: (context, vp, child) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: MainLastEntriesPane(
                        weightEntries: vp.lastWeightEntries,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
