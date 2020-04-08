import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  Widget child;

  CustomCard({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BOX_DECORATION,
      child: Material(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
        child: child,
      ),
    );
  }

  static BoxDecoration BOX_DECORATION = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(4.0),
    boxShadow: [
      BoxShadow(
        color: Color(0x144E4F72),
        offset: Offset(0, 16),
        blurRadius: 60,
      ),
    ],
  );
}
