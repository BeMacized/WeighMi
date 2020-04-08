import 'package:flutter/material.dart';
import 'package:weigh_mi/models/weight-entry.model.dart';
import 'package:weigh_mi/widgets/custom-card.widget.dart';
import 'package:weigh_mi/widgets/weight-entry.widget.dart';

class MainLastEntriesPane extends StatelessWidget {
  final List<WeightEntry> weightEntries;

  const MainLastEntriesPane({Key key, this.weightEntries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Last Measurements',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.title,
        ),
        if (weightEntries.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: CustomCard(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'No Data',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
            ),
          ),
        for (WeightEntry entry in weightEntries)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: WeightEntryWidget(
              weightEntry: entry,
            ),
          ),
      ],
    );
  }
}
