import 'package:flutter/material.dart';
import 'package:weigh_mi/widgets/list-item/nav-list-item.widget.dart';
import 'package:weigh_mi/widgets/pane.view-layout.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PaneViewLayout(
      title: 'Settings',
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            NavListItem(),
            NavListItem(),
            NavListItem(),
          ],
        ),
      ),
    );
  }
}
