import 'package:weigh_mi/models/weight-entry.model.dart';
import 'package:xiaomi_scale/xiaomi_scale.dart';

String getScaleUnitName(MiScaleUnit unit) {
  if (unit == null) return '';
  switch (unit) {
    case MiScaleUnit.LBS:
      return 'lbs';
    case MiScaleUnit.KG:
      return 'kg';
    default:
      return '?UNIT?';
  }
}

MiScaleUnit getScaleUnitForName(String str) {
  str = str.toLowerCase().trim();
  if (str == 'kg' || str == 'kilogram') return MiScaleUnit.KG;
  if (str == 'lbs' || str == 'lb' || str == 'pount') return MiScaleUnit.LBS;
  return null;
}

double lbsToKg(double value) => value / 2.2046;

double kgToLbs(double value) => value * 2.2046;

double getWeightDifference(WeightEntry a, WeightEntry b, MiScaleUnit unit) {
  switch (unit) {
    case MiScaleUnit.LBS:
      return b.getWeightLbs() - a.getWeightLbs();
    case MiScaleUnit.KG:
      return b.getWeightKg() - a.getWeightKg();
    default:
      throw Exception("Unsupported unit $unit");
  }
}
