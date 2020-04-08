import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:weigh_mi/models/weight-entry.model.dart';
import 'package:weigh_mi/utils/weight-utils.dart';
import 'package:xiaomi_scale/xiaomi_scale.dart';

List<WeightEntry> parseLibraCSV(String csvString) {
  List<String> lines = csvString.split('\n');
  MiScaleUnit unit = getScaleUnitForName(
    lines
        .firstWhere((line) => line.startsWith('#Units:'),
            orElse: () => '#Units:')
        .substring(7)
        .trim(),
  );
  if (unit == null) throw Exception('Unsupported weight unit');
  List<List<dynamic>> csvData = const CsvToListConverter().convert(
    lines
        .where((line) => line.trim().isNotEmpty && !line.startsWith('#'))
        .join('\n'),
    fieldDelimiter: ';',
    eol: '\n',
  );
  return csvData.map((row) {
    double weight;
    DateTime dateTime;
    try {
      weight = row[1];
    } catch (e) {
      throw Exception('Could not parse weight for all entries: $e');
    }
    try {
      dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(row[0]);
    } catch (e) {
      print(e);
      throw Exception('Could not parse datetime for all entries: ');
    }
    return WeightEntry(weight: weight, unit: unit, dateTime: dateTime);
  }).toList();
}
