import 'package:flutter/material.dart';

import 'list-item.widget.dart';

class NavListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListItem(
      icon: Icon(Icons.ac_unit),
      text: Text('AC Settings'),
      value: Text('on'),
    );
  }
}
