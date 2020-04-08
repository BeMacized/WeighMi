import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weigh_mi/models/stat-data.model.dart';

import 'custom-card.widget.dart';

enum Sentiment { POSITIVE, NEUTRAL, NEGATIVE }

enum Direction { UP, UNCHANGED, DOWN }

class Stat extends StatelessWidget {
  final Sentiment sentiment;
  final double value;
  final String unit;
  final String label;
  final Direction direction;

  Stat({
    this.value = 0.0,
    this.sentiment = Sentiment.NEUTRAL,
    this.unit = '',
    this.label = '',
    this.direction = Direction.UNCHANGED,
  });

  Stat.fromData(StatData data)
      : value = data.value,
        sentiment = data.sentiment,
        unit = data.unit,
        label = data.label,
        direction = data.direction;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  child: _getIconForDirection(),
                  padding: EdgeInsets.only(right: 6),
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: this.value.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.title.copyWith(
                              fontSize: 30,
                            ),
                      ),
                      TextSpan(
                        text: ' $unit',
                        style: Theme.of(context).textTheme.caption.copyWith(),
                      ),
                    ],
                  ),
                ),
                // Just for even spacing
                Opacity(
                  child: _getIconForDirection(),
                  opacity: 0,
                ),
              ],
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.caption.copyWith(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForSentiment() {
    switch (sentiment) {
      case Sentiment.POSITIVE:
        return Colors.lightGreen;
      case Sentiment.NEUTRAL:
        return Colors.blue;
      case Sentiment.NEGATIVE:
        return Colors.red;
    }
  }

  Icon _getIconForDirection() {
    switch (direction) {
      case Direction.UP:
        return Icon(
          Icons.arrow_drop_up,
          size: 25,
          color: _getColorForSentiment(),
        );
      case Direction.UNCHANGED:
        return Icon(
          Icons.trip_origin,
          size: 15,
          color: _getColorForSentiment(),
        );
      case Direction.DOWN:
        return Icon(
          Icons.arrow_drop_down,
          size: 25,
          color: _getColorForSentiment(),
        );
    }
  }
}
