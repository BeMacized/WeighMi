import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final Widget icon;
  final Widget text;
  final Widget value;

  const ListItem({
    Key key,
    this.icon,
    this.text,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 64,
            width: 64,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: icon,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black.withOpacity(0.08)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: text,
                    ),
                    if (value != null) value,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
