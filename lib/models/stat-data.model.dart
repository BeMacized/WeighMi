import 'package:weigh_mi/widgets/stat.widget.dart';

class StatData {
  final Sentiment sentiment;
  final double value;
  final String unit;
  final String label;
  final Direction direction;

  StatData({
    this.sentiment,
    this.value,
    this.unit,
    this.label,
    this.direction,
  });
}
