import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weigh_mi/providers/measure.provider.dart';
import 'package:weigh_mi/views/measure/widgets/weight-indicator.widget.dart';
import 'package:weigh_mi/widgets/custom-card.widget.dart';

import 'measure-view.provider.dart';

class MeasureView extends StatefulWidget {
  @override
  _MeasureViewState createState() => _MeasureViewState();
}

class _MeasureViewState extends State<MeasureView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Provider.of<MeasureProvider>(context, listen: false)
              .clearMeasurement();
          return false;
        },
        child: Material(
          color: Theme.of(context).backgroundColor,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        WeightIndicator(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 225),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            _buildSaveButton(),
                            SizedBox(height: 24),
                            _buildDismissButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return CustomCard(
      child: Consumer<MeasureViewProvider>(
        builder: (context, vp, child) {
          return FlatButton(
            color: Theme.of(context).primaryColor,
            disabledColor: Theme.of(context).primaryColor.withOpacity(0.3),
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: vp.canSave ? vp.saveMeasurement : null,
          );
        },
      ),
    );
  }

  Widget _buildDismissButton() {
    return CustomCard(
      child: Consumer<MeasureViewProvider>(
        builder: (context, vp, child) {
          return OutlineButton(
            child: Text('Dismiss'),
            onPressed: vp.dismissMeasurement,
          );
        },
      ),
    );
  }
}
