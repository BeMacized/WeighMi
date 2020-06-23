import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weigh_mi/models/weight-entry.model.dart';

const ENTRIES_PREF_KEY = 'WEIGHT_ENTRIES';

class WeightEntryProvider extends ChangeNotifier {
  List<WeightEntry> _entries = [];

  List<WeightEntry> get entries => _entries.sublist(0);

  Future<void> deleteEntry(WeightEntry entry, {BuildContext context}) async {
    // If context was provided, ask user for confirmation
    if (context != null) {
      bool accepted = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete measurement?'),
            content: const Text(
                'You are about to delete a measurement. Are you sure you want to delete it?'),
            actions: <Widget>[
              FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child:
                    const Text('DELETE', style: TextStyle(color: Colors.red)),
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
    _entries.remove(entry);
    notifyListeners();
    saveEntries();
  }

  void addEntry(WeightEntry entry) {
    if (_entries.contains(entry)) return;
    _entries.add(entry);
    _entries.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    notifyListeners();
    saveEntries();
  }

  void replaceEntry(WeightEntry entry, WeightEntry newEntry) {
    int index = _entries.indexOf(entry);
    if (index < 0) throw Exception("Entry does not exist in list!");
    _entries.removeAt(index);
    _entries.insert(index, newEntry);
    notifyListeners();
    saveEntries();
  }

  Future<void> loadEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(ENTRIES_PREF_KEY)) {
      saveEntries();
    } else {
      String entriesStr = prefs.getString(ENTRIES_PREF_KEY);
      _entries = List.from(jsonDecode(entriesStr))
          .map((entry) => WeightEntry.fromJson(entry))
          .toList();
      notifyListeners();
    }
  }

  Future<void> saveEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(ENTRIES_PREF_KEY, jsonEncode(_entries));
  }

  void deleteAllEntries() {
    _entries = [];
    notifyListeners();
    saveEntries();
  }
}
