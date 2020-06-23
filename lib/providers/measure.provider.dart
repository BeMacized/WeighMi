import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xiaomi_scale/xiaomi_scale.dart';

import '../globals.dart';

class MeasureProvider {
  StreamSubscription _measurementSubscription;
  StreamSubscription _bleStatusSubscription;

  // Private streams
  BehaviorSubject<MiScaleMeasurement> _measurement = BehaviorSubject.seeded(null);

  // Public streams
  Stream<MiScaleMeasurement> get measurement => _measurement.asBroadcastStream();

  MeasureProvider() {
    _bleStatusSubscription = FlutterReactiveBle().statusStream.listen(_onBleStatus);
  }

  void startMeasuring() async {
    // Stop if we're already measuring
    if (_measurementSubscription != null) return;
    // Start measuring
    _measurementSubscription = MiScale.instance.takeMeasurements().listen(_onMeasurement);
  }

  void stopMeasuring() {
    _measurementSubscription?.cancel();
    _measurementSubscription = null;
    clearMeasurement();
  }

  // Event Handlers

  void _onMeasurement(MiScaleMeasurement measurement) {
    if (_measurement.value == null || measurement.deviceId == _measurement.value.deviceId) {
      if (_measurement.value == null) Application.navigator.pushNamed('/measure');
      _measurement.add(measurement);
    }
  }

  void _onBleStatus(BleStatus status) {
    if (status == BleStatus.ready)
      startMeasuring();
    else if (_measurementSubscription != null) stopMeasuring();
  }

  // Public functions

  void clearMeasurement() {
    if (_measurement.value == null) return;
    _measurement.add(null);
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
}
