import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class BLEErrorBar extends StatefulWidget {
  @override
  _BLEErrorBarState createState() => _BLEErrorBarState();
}

class _BLEErrorBarState extends State<BLEErrorBar> {
  StreamSubscription _statusSubscription;

  VoidCallback action;
  String actionLabel;
  String error;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: error == null ? 0 : 44,
      color: Colors.red,
      child: ClipRect(
        child: SizedBox(
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      error ?? '',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.body1.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              if (actionLabel != null)
                Container(
                  color: Colors.red.shade700,
                  child: ButtonTheme(
                    padding: EdgeInsets.all(0),
                    child: FlatButton(
                      textColor: Colors.white,
                      child: Text(actionLabel ?? ''),
                      onPressed: action,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _statusSubscription = FlutterReactiveBle().statusStream.listen((status) {
      setState(() {
        error = null;
        actionLabel = null;
        action = null;
        switch (status) {
          case BleStatus.unauthorized:
            error = 'Missing location permission';
            actionLabel = 'Fix';
            action = fixPermissions;
            break;
          case BleStatus.poweredOff:
            error = 'Bluetooth turned off';
            break;
          case BleStatus.locationServicesDisabled:
            error = 'Location turned off';
            break;
          case BleStatus.unsupported:
            error = 'Missing bluetooth support';
            break;
          case BleStatus.unknown:
          case BleStatus.ready:
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
  }

  Future<void> fixPermissions() async {
    PermissionStatus status = await Permission.locationWhenInUse.request();
    switch (status) {
      case PermissionStatus.undetermined:
        break;
      case PermissionStatus.granted:
        Fluttertoast.showToast(
          msg: 'Location permission granted',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        break;
      case PermissionStatus.denied:
        Fluttertoast.showToast(
          msg: 'Location permission denied',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        break;
      case PermissionStatus.restricted:
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Permissions restricted'),
              content: const Text(
                'Location permissions cannot be granted as they are restricted on your device. (Possibly due to parental restrictions)',
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'OK',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
        break;
      case PermissionStatus.permanentlyDenied:
        bool _openAppSettings = await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Location permissions'),
              content: const Text(
                  'As you have permanently denied location permissions, you can only turn them back on through the application settings. Do you want to open the application settings now?'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text(
                    'OPEN SETTINGS',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                )
              ],
            );
          },
        );
        if (_openAppSettings != null && _openAppSettings) openAppSettings();
        break;
    }
  }
}
