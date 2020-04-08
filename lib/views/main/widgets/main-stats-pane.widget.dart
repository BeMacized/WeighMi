import 'package:flutter/material.dart';
import 'package:weigh_mi/models/stat-data.model.dart';
import 'package:weigh_mi/widgets/stat.widget.dart';

class MainStatsPane extends StatelessWidget {
  final List<StatData> stats;

  const MainStatsPane({Key key, this.stats = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int row = 0; row < stats.length; row += 2) ...[
          if (row != 0) SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: Stat.fromData(stats[row]),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: row == stats.length - 1
                    ? Container()
                    : Stat.fromData(stats[row + 1]),
              ),
            ],
          )
        ],
      ],
    );
  }
}
