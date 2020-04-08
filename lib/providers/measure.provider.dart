import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xiaomi_scale/xiaomi_scale.dart';

import '../globals.dart';

class MeasureProvider extends ChangeNotifier {
  StreamSubscription _measurementSubscription;

  MeasureProvider();

  @override
  void dispose() {
    _measurementSubscription?.cancel();
    super.dispose();
  }

  void startMeasuring() async {
    // Stop if we're already measuring
    if (_measurementSubscription != null) return;

    // Handle permissions
    if (!(await _handlePermissions())) return;

    // Start measuring
    _measurementSubscription =
        MiScale.instance.takeMeasurements().listen(_onMeasurement);
  }

  void stopMeasuring() {
    _measurementSubscription?.cancel();
    _measurementSubscription = null;
    clearMeasurement();
  }

  Future<bool> _handlePermissions() async {
    PermissionStatus status = await Permission.location.status;
    if (status.isUndetermined || status.isDenied) {
      status = await Permission.location.request();
    }
    return status.isGranted;
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
