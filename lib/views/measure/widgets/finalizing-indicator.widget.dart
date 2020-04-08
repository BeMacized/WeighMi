import 'dart:async';

import 'package:flutter/material.dart';

class FinalizingIndicator extends StatefulWidget {
  final bool animating;

  const FinalizingIndicator({Key key, this.animating = true}) : super(key: key);

  @override
  _FinalizingIndicatorState createState() => _FinalizingIndicatorState();
}

class _FinalizingIndicatorState extends State<FinalizingIndicator> {
  int highlightIndex = -1;
  StreamSubscription animationSubscription;

  @override
  void initState() {
    didUpdateWidget(null);
    super.initState();
  }

  @override
  void dispose() {
    stopAnimation();
    super.dispose();
  }

  @override
  void didUpdateWidget(FinalizingIndicator oldWidget) {
    if ((oldWidget == null || !oldWidget.animating) && widget.animating) {
      startAnimation();
    } else if ((oldWidget == null || oldWidget.animating) &&
        !widget.animating) {
      stopAnimation();
    }
  }

  startAnimation() {
    highlightIndex = 0;
    animationSubscription =
        Stream.periodic(Duration(milliseconds: 250)).listen((_) {
      setState(() {
        if (highlightIndex < 6)
          highlightIndex++;
        else
          highlightIndex = 0;
      });
    });
  }

  stopAnimation() {
    highlightIndex = -1;
    animationSubscription?.cancel();
    animationSubscription = null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.animating ? 1.0 : 0.0,
      duration: Duration(milliseconds: 250),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 0; i < 6; i++) _buildLine(i),
        ],
      ),
    );
  }

  Widget _buildLine(int index) {
    return AnimatedOpacity(
      opacity: highlightIndex == index ? 1.0 : 0.25,
      duration: Duration(milliseconds: 125),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
          height: 4,
          width: 15,
        ),
      ),
    );
  }
}
