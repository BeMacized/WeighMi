import 'package:flutter/material.dart';
import 'package:weigh_mi/utils/weight-utils.dart';
import 'package:xiaomi_scale/xiaomi_scale.dart';

class CurrentWeight extends StatelessWidget {
  final double weight;
  final double bmi;
  final MiScaleUnit unit;

  CurrentWeight({
    this.weight,
    this.bmi,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Current Weight',
          style: Theme.of(context).textTheme.caption.copyWith(
                color: Colors.white.withOpacity(0.65),
              ),
        ),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              if (weight != null)
                TextSpan(
                  text: weight.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.title.copyWith(
                        color: Colors.white,
                        fontSize: 70,
                        height: 1.25,
                      ),
                ),
              if (weight != null && unit != null)
                TextSpan(
                  text: ' ' + getScaleUnitName(unit),
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: Colors.white.withOpacity(1.0),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              if (weight == null)
                TextSpan(
                  text: 'No Data',
                  style: Theme.of(context).textTheme.title.copyWith(
                        color: Colors.white,
                      ),
                ),
            ],
          ),
        ),
        if (bmi != null)
          Text(
            'BMI ${bmi.toStringAsFixed(1)}',
            style: Theme.of(context).textTheme.caption.copyWith(
                  color: Colors.white.withOpacity(0.65),
                ),
          ),
      ],
    );
  }
}
