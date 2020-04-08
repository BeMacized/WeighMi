import 'package:flutter/foundation.dart';
import 'package:weigh_mi/utils/weight-utils.dart';
import 'package:xiaomi_scale/xiaomi_scale.dart';

class WeightEntry {
  final double weight;
  final MiScaleUnit unit;
  final DateTime dateTime;

  WeightEntry(
      {@required this.weight, @required this.unit, @required this.dateTime});

  WeightEntry.fromJson(Map<String, dynamic> json)
      : weight = json['weight'],
        unit = MiScaleUnit.values.firstWhere(
          (v) => v.toString().split('.')[1] == json['unit'],
          orElse: () => null,
        ),
        dateTime = DateTime.parse(json['dateTime']);

  Map<String, dynamic> toJson() => {
        'weight': weight,
        'unit': unit.toString().split('.')[1],
        'dateTime': dateTime.toIso8601String(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeightEntry &&
          runtimeType == other.runtimeType &&
          weight == other.weight &&
          unit == other.unit &&
          dateTime == other.dateTime;

  @override
  int get hashCode => weight.hashCode ^ unit.hashCode ^ dateTime.hashCode;

  double getWeightKg() {
    switch (unit) {
      case MiScaleUnit.LBS:
        return lbsToKg(weight);
      case MiScaleUnit.KG:
        return weight;
      default:
        throw Exception("Unsupported unit");
    }
  }

  double getWeightLbs() {
    switch (unit) {
      case MiScaleUnit.LBS:
        return weight;
      case MiScaleUnit.KG:
        return kgToLbs(weight);
      default:
    }
  }

  @override
  String toString() {
    return 'WeightEntry{weight: $weight, unit: $unit, dateTime: $dateTime}';
  }
}
