import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weigh_mi/models/stat-data.model.dart';
import 'package:weigh_mi/models/weight-entry.model.dart';
import 'package:weigh_mi/providers/weight-entry.provider.dart';
import 'package:weigh_mi/utils/libra-utils.dart';
import 'package:weigh_mi/utils/weight-utils.dart';
import 'package:weigh_mi/widgets/stat.widget.dart';
import 'package:xiaomi_scale/xiaomi_scale.dart';

class MainViewProvider {
  // Dependencies
  WeightEntryProvider _weightEntryProvider;

  // Private streams
  PublishSubject<void> _viewDispose = PublishSubject();
  BehaviorSubject<double> _currentWeight = BehaviorSubject.seeded(null);
  BehaviorSubject<double> _currentBMI = BehaviorSubject.seeded(null);
  BehaviorSubject<MiScaleUnit> _weightUnit = BehaviorSubject.seeded(null);
  BehaviorSubject<List<WeightEntry>> _lineChartData = BehaviorSubject.seeded([]);
  BehaviorSubject<List<StatData>> _statDatas = BehaviorSubject.seeded([]);
  BehaviorSubject<List<WeightEntry>> _lastWeightEntries = BehaviorSubject.seeded([]);

  // Public streams
  Stream<double> get currentWeight => _currentWeight.asBroadcastStream();

  Stream<double> get currentBMI => _currentBMI.asBroadcastStream();

  Stream<MiScaleUnit> get weightUnit => _weightUnit.asBroadcastStream();

  Stream<List<WeightEntry>> get lineChartData => _lineChartData.asBroadcastStream();

  Stream<List<StatData>> get statDatas => _statDatas.asBroadcastStream();

  Stream<List<WeightEntry>> get lastWeightEntries => _lastWeightEntries.asBroadcastStream();

  MainViewProvider(this._weightEntryProvider);

  // Event handlers

  void _onWeightEntriesUpdated(List<WeightEntry> entries) {
    try {
      WeightEntry lastEntry = entries.isNotEmpty ? entries.last : null;
      _currentWeight.add(lastEntry?.weight);
      _weightUnit.add(lastEntry?.unit);
      // TODO: Do BMI calculation once we have the user's height
      _currentBMI.add(null);
      _statDatas.add([
        _getStatDataForDays(entries, 7),
        _getStatDataForDays(entries, 14),
        _getStatDataForDays(entries, 30),
        _getStatDataForTotal(entries),
      ]);
      _lastWeightEntries.add(
        entries.sublist(max(entries.length - 5, 0)).reversed.toList(),
      );
      _lineChartData.add(_buildLineChartData(entries));
    } catch (e, stacktrace) {
      print('Error MainViewProvider#onWeightEntriesChanged: $e\n$stacktrace');
    }
  }

  Future<void> onViewInit() async {
    _weightEntryProvider.entries.takeUntil(_viewDispose).listen((entries) => _onWeightEntriesUpdated(entries));
  }

  Future<void> onViewDispose() async {
    _viewDispose.add(null);
  }

  // Actions

  Future<void> libraImport() async {
    try {
      File file = await FilePicker.getFile(type: FileType.custom, fileExtension: 'csv');
      if (file == null) return;
      List<WeightEntry> entries = parseLibraCSV(file.readAsStringSync());
      entries.forEach((entry) {
        _weightEntryProvider.addEntry(entry);
      });
      Fluttertoast.showToast(
        msg: 'Imported ${entries.length} entries!',
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Could not import libra data: $e',
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> deleteAllMeasurements(BuildContext context) async {
    bool accepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete all measurements?'),
          content: const Text('This will delete all measurements from your device.'),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: const Text('DELETE', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    );

    if (accepted) {
      _weightEntryProvider.deleteAllEntries();
    }
  }

  // Event handlers

  // Private utils

  StatData _getStatDataForTotal(List<WeightEntry> entries) {
    // Determine difference
    double value = entries.isEmpty
        ? 0
        : getWeightDifference(
            entries.first,
            entries.last,
            entries.last.unit,
          );
    // Determine label
    String label =
        entries.isEmpty ? 'Overall Change' : 'Change since ${DateFormat('d MMM yyyy').format(entries.first.dateTime)}';
    // Construct stat data
    return StatData(
      label: label,
      value: value,
      unit: getScaleUnitName(
        entries.isEmpty ? null : entries.last.unit,
      ),
      sentiment: value > 0 ? Sentiment.NEGATIVE : value < 0 ? Sentiment.POSITIVE : Sentiment.NEUTRAL,
      direction: value > 0 ? Direction.UP : value < 0 ? Direction.DOWN : Direction.UNCHANGED,
    );
  }

  StatData _getStatDataForDays(List<WeightEntry> entries, int days) {
    // Get applicable entries
    List<WeightEntry> lastEntries = entries
        .where(
          (e) =>
              e.dateTime.isAfter(DateTime.now().subtract(Duration(days: days))) && e.dateTime.isBefore(DateTime.now()),
        )
        .toList();
    // Add extra measurement from before range
    if (lastEntries.isNotEmpty) {
      int firstIndex = entries.indexOf(lastEntries[0]);
      if (firstIndex > 0) lastEntries.insert(0, entries[firstIndex - 1]);
    }
    // Calculate change value
    double value = lastEntries.isEmpty
        ? 0
        : getWeightDifference(
            lastEntries.first,
            lastEntries.last,
            lastEntries.last.unit,
          );
    // Construct stat data
    return StatData(
      label: 'Last $days day${days == 1 ? '' : 's'}',
      value: value,
      unit: getScaleUnitName(
        lastEntries.isEmpty ? null : lastEntries.last.unit,
      ),
      sentiment: value > 0 ? Sentiment.NEGATIVE : value < 0 ? Sentiment.POSITIVE : Sentiment.NEUTRAL,
      direction: value > 0 ? Direction.UP : value < 0 ? Direction.DOWN : Direction.UNCHANGED,
    );
  }

  List<WeightEntry> _buildLineChartData(List<WeightEntry> entries) {
    if (entries.isEmpty) return [];
    // Get all entries within the past 2 weeks
    List<WeightEntry> chartEntries = entries
        .where(
          (e) => e.dateTime.isAfter(DateTime.now().subtract(Duration(days: 14))) && e.dateTime.isBefore(DateTime.now()),
        )
        .toList();
    // Extras
    if (chartEntries.isNotEmpty) {
      // Add last measurement before the first (so we can show a line going off the side of the chart)
      if (entries.indexOf(chartEntries.first) > 0) {
        chartEntries.insert(
          0,
          entries[entries.indexOf(chartEntries.first) - 1],
        );
      }
      // Add last known measurement if we have no measurements
      if (chartEntries.isEmpty) {
        chartEntries.add(entries.last);
      }
    }

    return chartEntries;
  }
}
