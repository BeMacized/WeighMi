import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weigh_mi/models/weight-entry.model.dart';

const ENTRIES_PREF_KEY = 'WEIGHT_ENTRIES';

class WeightEntryProvider {
  // Private streams
  BehaviorSubject<List<WeightEntry>> _entries = BehaviorSubject.seeded([]);

  // Public streams
  Stream<List<WeightEntry>> get entries => _entries.asBroadcastStream();

  WeightEntryProvider() {
    entries.skip(1).listen((event) {
      saveEntries();
    });
  }

  // Actions
  Future<void> deleteEntry(WeightEntry entry, {BuildContext context}) async {
    // If context was provided, ask user for confirmation
    if (context != null) {
      bool accepted = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete measurement?'),
            content: const Text('You are about to delete a measurement. Are you sure you want to delete it?'),
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
      if (accepted == null || !accepted) return;
    }
    // Remove the entry
    _entries.add(List<WeightEntry>.of(_entries.value)..remove(entry));
  }

  void addEntry(WeightEntry entry) {
    if (_entries.value.contains(entry)) return;
    var newEntries = List<WeightEntry>.from(_entries.value)..add(entry);
    newEntries.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    _entries.add(newEntries);
  }

  void replaceEntry(WeightEntry entry, WeightEntry newEntry) {
    var newEntries = List<WeightEntry>.from(_entries.value);
    int index = newEntries.indexOf(entry);
    if (index < 0) throw Exception("Entry does not exist in list!");
    newEntries.removeAt(index);
    newEntries.insert(index, newEntry);
    _entries.add(newEntries);
  }

  Future<void> loadEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(ENTRIES_PREF_KEY)) {
      print('CLEARING ENTRIES');
      saveEntries();
    } else {
      print('LOADING ENTRIES');
      String entriesStr = prefs.getString(ENTRIES_PREF_KEY);
      var newEntries =
          List.from(jsonDecode(entriesStr)).map<WeightEntry>((entry) => WeightEntry.fromJson(entry)).toList();
      _entries.add(newEntries);
    }
  }

  Future<void> saveEntries() async {
    print('SAVING ENTRIES');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(ENTRIES_PREF_KEY, jsonEncode(_entries.value));
  }

  void deleteAllEntries() {
    _entries.add([]);
  }
}
