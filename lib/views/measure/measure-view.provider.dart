import 'package:rxdart/rxdart.dart';
import 'package:weigh_mi/models/weight-entry.model.dart';
import 'package:weigh_mi/providers/measure.provider.dart';
import 'package:weigh_mi/providers/weight-entry.provider.dart';
import 'package:xiaomi_scale/xiaomi_scale.dart';

class MeasureViewProvider {
  // Dependencies
  MeasureProvider _measureProvider;
  WeightEntryProvider _weightEntryProvider;

  // Private streams
  PublishSubject<void> _viewDispose = PublishSubject();
  BehaviorSubject<double> _weight = BehaviorSubject.seeded(null);
  BehaviorSubject<MiScaleUnit> _unit = BehaviorSubject.seeded(null);
  BehaviorSubject<String> _status = BehaviorSubject.seeded('');
  BehaviorSubject<bool> _canSave = BehaviorSubject.seeded(false);
  BehaviorSubject<bool> _showFinalizingAnimation = BehaviorSubject.seeded(false);
  BehaviorSubject<bool> _blinkStatus = BehaviorSubject.seeded(true);

  // Public streams
  Stream<double> get weight => _weight.asBroadcastStream().distinct();

  Stream<MiScaleUnit> get unit => _unit.asBroadcastStream().distinct();

  Stream<String> get status => _status.asBroadcastStream().distinct();

  Stream<bool> get canSave => _canSave.asBroadcastStream().distinct();

  Stream<bool> get showFinalizingAnimation => _showFinalizingAnimation.asBroadcastStream().distinct();

  Stream<bool> get blinkStatus => _blinkStatus.asBroadcastStream().distinct();

  MeasureViewProvider(this._measureProvider, this._weightEntryProvider);

  // Event Handlers

  _onMeasurementUpdated(MiScaleMeasurement measurement) {
    _weight.add(measurement?.weight);
    _unit.add(measurement?.unit);
    _status.add(_getStatusForStage(measurement?.stage));
    _showFinalizingAnimation.add(measurement?.stage == MiScaleMeasurementStage.STABILIZED);
    _canSave.add(measurement?.stage == MiScaleMeasurementStage.MEASURED);
    _blinkStatus.add(measurement?.stage == MiScaleMeasurementStage.MEASURING);
  }

  Future<void> onViewInit() async {
    _measureProvider.measurement.takeUntil(_viewDispose).listen((measurement) => _onMeasurementUpdated(measurement));
  }

  Future<void> onViewDispose() async {
    _viewDispose.add(null);
  }

  //
  // Public actions
  //

  dismissMeasurement() {
    _measureProvider.clearMeasurement();
  }

  saveMeasurement() async {
    MiScaleMeasurement measurement = await _measureProvider.measurement.take(1).first;
    if (measurement == null || measurement.stage != MiScaleMeasurementStage.MEASURED) return;
    // Save entry
    _weightEntryProvider.addEntry(WeightEntry(
      weight: measurement.weight,
      unit: measurement.unit,
      dateTime: measurement.dateTime,
    ));
    // Clear measurement
    _measureProvider.clearMeasurement();
  }

  // Private utilities

  String _getStatusForStage(MiScaleMeasurementStage stage) {
    if (stage == null) return '';
    switch (stage) {
      case MiScaleMeasurementStage.WEIGHT_REMOVED:
        return 'Weight Removed';
      case MiScaleMeasurementStage.MEASURING:
        return 'Measuring';
      case MiScaleMeasurementStage.STABILIZED:
        return '';
      case MiScaleMeasurementStage.MEASURED:
        return 'Complete';
    }
  }
}
