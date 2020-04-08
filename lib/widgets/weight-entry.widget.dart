import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weigh_mi/models/weight-entry.model.dart';
import 'package:weigh_mi/providers/weight-entry.provider.dart';
import 'package:weigh_mi/utils/weight-utils.dart';

import 'custom-card.widget.dart';

class WeightEntryWidget extends StatelessWidget {
  final WeightEntry weightEntry;

  WeightEntryWidget({@required this.weightEntry});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    weightEntry.weight.toStringAsFixed(2) +
                        ' ' +
                        getScaleUnitName(weightEntry.unit),
                    style: Theme.of(context).textTheme.body1.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(DateFormat('HH:mm, EEEE, MMMM d, y')
                      .format(weightEntry.dateTime)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.black87),
              onPressed: () {
                Provider.of<WeightEntryProvider>(context, listen: false)
                    .deleteEntry(weightEntry, context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
