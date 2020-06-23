import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weigh_mi/utils/weight-utils.dart';
import 'package:weigh_mi/widgets/blinker.widget.dart';
import 'package:weigh_mi/widgets/custom-card.widget.dart';

import '../measure-view.provider.dart';
import 'finalizing-indicator.widget.dart';

class WeightIndicator extends StatelessWidget {
  static const double _SCALE = 220;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        width: _SCALE,
        height: _SCALE,
        decoration: CustomCard.BOX_DECORATION.copyWith(borderRadius: BorderRadius.circular(_SCALE / 2)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 19,
                child: _buildFinalizingIndicator(context),
              ),
              _buildWeightText(context),
              Container(
                height: 19,
                child: _buildStatus(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinalizingIndicator(BuildContext context) {
    return Center(
      child: StreamBuilder<bool>(
        stream: Provider.of<MeasureViewProvider>(context).showFinalizingAnimation,
        initialData: false,
        builder: (context, snapshot) => FinalizingIndicator(
          animating: snapshot.data,
        ),
      ),
    );
  }

  Widget _buildWeightText(BuildContext context) {
    return StreamBuilder<Map>(
      stream: Rx.combineLatest2(
        Provider.of<MeasureViewProvider>(context).weight,
        Provider.of<MeasureViewProvider>(context).unit,
        (weight, unit) => {'weight': weight, 'unit': unit},
      ),
      initialData: {},
      builder: (context, snapshot) {
        return RichText(
          text: TextSpan(
            children: <TextSpan>[
              if (snapshot.data['weight'] != null)
                TextSpan(
                  text: snapshot.data['weight']?.toStringAsFixed(2) ?? '',
                  style: Theme.of(context).textTheme.title.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: 50,
                        height: 1.25,
                      ),
                ),
              if (snapshot.data['weight'] != null && snapshot.data['unit'] != null)
                TextSpan(
                  text: ' ' + getScaleUnitName(snapshot.data['unit']),
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              if (snapshot.data['weight'] == null)
                TextSpan(
                  text: 'Waiting',
                  style: Theme.of(context).textTheme.title.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatus(BuildContext context) {
    return StreamBuilder<bool>(
      stream: Provider.of<MeasureViewProvider>(context).blinkStatus,
      initialData: true,
      builder: (context, blinkSnapshot) {
        return Blinker(
          blinking: blinkSnapshot.data ? BlinkerState.BLINKING : BlinkerState.ON,
          minOpacity: 0.25,
          child: StreamBuilder<String>(
            stream: Provider.of<MeasureViewProvider>(context).status,
            initialData: '',
            builder: (context, statusSnapshot) {
              return Text(
                statusSnapshot.data ?? '',
                style: Theme.of(context).textTheme.subtitle.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              );
            },
          ),
        );
      },
    );
  }
}
