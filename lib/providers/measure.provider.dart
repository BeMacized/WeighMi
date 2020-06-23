import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:xiaomi_scale/xiaomi_scale.dart';

import '../globals.dart';

class MeasureProvider extends ChangeNotifier {
  StreamSubscription _measurementSubscription;
  StreamSubscription _bleStatusSubscription;

  MeasureProvider() {
    _bleStatusSubscription =
        FlutterReactiveBle().statusStream.listen(_onBleStatus);
  }

  @override
  void dispose() {
    _measurementSubscription?.cancel();
    _bleStatusSubscription?.cancel();
    super.dispose();
  }

  void startMeasuring() async {
    // Stop if we're already measuringgirt
    if (_measurementSubscription != null) return;
    // Start measuring
    _measurementSubscription =
        MiScale.instance.takeMeasurements().listen(_onMeasurement);
  }

  void stopMeasuring() {
    _measurementSubscription?.cancel();
    _measurementSubscription = null;
    clearMeasurement();
  }

  //
  // Event Handlers
  //

  void _onMeasurement(MiScaleMeasurement measurement) {
    if (_measurement == null || measurement.deviceId == _measurement.deviceId) {
      if (_measurement == null) Application.navigator.pushNamed('/measure');
      _updateMeasurement(measurement);
    }
  }

  void _onBleStatus(BleStatus status) {
    if (status == BleStatus.ready) startMeasuring();
    else if (_measurementSubscription != null) stopMeasuring();
  }

  //
  // Public functions
  //

  void clearMeasurement() {
    if (_measurement == null) return;
    _updateMeasurement(null);
    Application.navigator.popUntil(
      (route) => route.settings.name != '/measure',
    );
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
        if (_measurementSubscription == null) startMeasuring();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (_measurementSubscription != null) stopMeasuring();
        break;
    }
  }

  //
  // Fields
  //

  MiScaleMeasurement _measurement;

  MiScaleMeasurement get measurement => _measurement;

  void _updateMeasurement(MiScaleMeasurement measurement) {
    _measurement = measurement;
    notifyListeners();
  }
}
