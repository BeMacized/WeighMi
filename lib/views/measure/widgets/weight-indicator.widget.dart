import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        decoration: CustomCard.BOX_DECORATION
            .copyWith(borderRadius: BorderRadius.circular(_SCALE / 2)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 19,
                child: _buildFinalizingIndicator(),
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

  Widget _buildFinalizingIndicator() {
    return Center(
      child: Consumer<MeasureViewProvider>(
        builder: (context, vp, child) => FinalizingIndicator(
          animating: vp.showFinalizingAnimation,
        ),
      ),
    );
  }

  Widget _buildWeightText(BuildContext context) {
    return Consumer<MeasureViewProvider>(builder: (context, vp, child) {
      return RichText(
        text: TextSpan(
          children: <TextSpan>[
            if (vp.weight != null)
              TextSpan(
                text: vp.weight.toStringAsFixed(2),
                style: Theme.of(context).textTheme.title.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: 50,
                      height: 1.25,
                    ),
              ),
            if (vp.weight != null && vp.unit != null)
              TextSpan(
                text: ' ' + getScaleUnitName(vp.unit),
                style: Theme.of(context).textTheme.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            if (vp.weight == null)
              TextSpan(
                text: 'Waiting',
                style: Theme.of(context).textTheme.title.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildStatus(BuildContext context) {
    return Consumer<MeasureViewProvider>(
      builder: (context, vp, child) {
        return Blinker(
          blinking: vp.blinkStatus ? BlinkerState.BLINKING : BlinkerState.ON,
          minOpacity: 0.25,
          child: child,
        );
      },
      child: Consumer<MeasureViewProvider>(
        builder: (context, vp, child) {
          return Text(
            vp.status ?? '',
            style: Theme.of(context).textTheme.subtitle.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          );
        },
      ),
    );
  }
}
