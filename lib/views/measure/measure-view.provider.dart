import 'package:flutter/material.dart';
import 'package:weigh_mi/models/weight-entry.model.dart';
import 'package:weigh_mi/providers/measure.provider.dart';
import 'package:weigh_mi/providers/weight-entry.provider.dart';
import 'package:xiaomi_scale/xiaomi_scale.dart';

class MeasureViewProvider extends ChangeNotifier {
  MeasureProvider _measureProvider;
  WeightEntryProvider _weightEntryProvider;

  MeasureViewProvider();

  //
  // Event Handlers
  //

  dependencyUpdate(
    MeasureProvider measureProvider,
    WeightEntryProvider weightEntryProvider,
  ) {
    this._measureProvider = measureProvider;
    this._weightEntryProvider = weightEntryProvider;
    _updateWeight(measureProvider.measurement?.weight);
    _updateUnit(measureProvider.measurement?.unit);
    _updateStatus(measureProvider.measurement?.stage);
    _updateShowFinalizingAnimation(measureProvider.measurement?.stage ==
        MiScaleMeasurementStage.STABILIZED);
    _updateCanSave(
        measureProvider.measurement?.stage == MiScaleMeasurementStage.MEASURED);
    _updateBlinkStatus(measureProvider.measurement?.stage ==
        MiScaleMeasurementStage.MEASURING);
  }

  //
  // Public actions
  //

  dismissMeasurement() {
    _measureProvider.clearMeasurement();
  }

  saveMeasurement() {
    if (_measureProvider.measurement == null ||
        _measureProvider.measurement.stage != MiScaleMeasurementStage.MEASURED)
      return;
    // Save entry
    _weightEntryProvider.addEntry(WeightEntry(
      weight: _measureProvider.measurement.weight,
      unit: _measureProvider.measurement.unit,
      dateTime: _measureProvider.measurement.dateTime,
    ));
    // Clear measurement
    _measureProvider.clearMeasurement();
  }

  //
  // Fields
  //

  double _weight;

  double get weight => _weight;

  void _updateWeight(double value) {
    if (value == null || value == _weight) return;
    _weight = value;
    notifyListeners();
  }

  MiScaleUnit _unit;

  MiScaleUnit get unit => _unit;

  void _updateUnit(MiScaleUnit value) {
    if (value == null || value == _unit) return;
    _unit = value;
    notifyListeners();
  }

  String _status = '';

  String get status => _status;

  void _updateStatus(MiScaleMeasurementStage stage) {
    if (stage == null) _status = '';
    switch (stage) {
      case MiScaleMeasurementStage.WEIGHT_REMOVED:
        _status = 'Weight Removed';
        break;
      case MiScaleMeasurementStage.MEASURING:
        _status = 'Measuring';
        break;
      case MiScaleMeasurementStage.STABILIZED:
        _status = '';
        break;
      case MiScaleMeasurementStage.MEASURED:
        _status = 'Complete';
        break;
    }
    notifyListeners();
  }

  bool _canSave = false;

  bool get canSave => _canSave;

  void _updateCanSave(bool value) {
    if (value == null || value == _canSave) return;
    _canSave = value;
    notifyListeners();
  }

  bool _showFinalizingAnimation = false;

  bool get showFinalizingAnimation => _showFinalizingAnimation;

  void _updateShowFinalizingAnimation(bool value) {
    if (value == null || value == _showFinalizingAnimation) return;
    _showFinalizingAnimation = value;
    notifyListeners();
  }

  bool _blinkStatus = true;

  bool get blinkStatus => _blinkStatus;

  void _updateBlinkStatus(bool value) {
    if (value == null || value == _blinkStatus) return;
    _blinkStatus = value;
    notifyListeners();
  }
}
