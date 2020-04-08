import 'dart:async';

import 'package:flutter/material.dart';

enum BlinkerState { OFF, BLINKING, ON }

class Blinker extends StatefulWidget {
  final Widget child;
  final BlinkerState blinking;
  final Duration speed;
  final double minOpacity;
  final double maxOpacity;

  const Blinker({
    Key key,
    this.blinking = BlinkerState.BLINKING,
    this.speed = const Duration(milliseconds: 500),
    this.child,
    this.minOpacity = 0,
    this.maxOpacity = 1,
  })  : assert(minOpacity < maxOpacity),
        assert(minOpacity >= 0),
        assert(maxOpacity <= 1),
        assert(speed != null),
        assert(blinking != null),
        super(key: key);

  @override
  _BlinkerState createState() => _BlinkerState();
}

class _BlinkerState extends State<Blinker> {
  double opacity;
  StreamSubscription animationSubscription;

  @override
  void initState() {
    super.initState();
    opacity = widget.blinking == BlinkerState.OFF
        ? widget.minOpacity
        : widget.maxOpacity;
    if (widget.blinking == BlinkerState.BLINKING) {
      animationSubscription =
          Stream.periodic(widget.speed).listen((_) => toggleOpacity());
    }
  }

  toggleOpacity() {
    setState(() {
      if (opacity > widget.minOpacity) {
        opacity = widget.minOpacity;
      } else {
        opacity = widget.maxOpacity;
      }
    });
  }

  @override
  void didUpdateWidget(Blinker oldWidget) {
    if (widget.blinking == BlinkerState.OFF) {
      animationSubscription?.cancel();
      setState(() {
        opacity = widget.minOpacity;
      });
    } else if (widget.blinking == BlinkerState.ON) {
      animationSubscription?.cancel();
      setState(() {
        opacity = widget.maxOpacity;
      });
    } else if (widget.blinking == BlinkerState.BLINKING) {
      animationSubscription?.cancel();
      animationSubscription =
          Stream.periodic(widget.speed).listen((_) => toggleOpacity());
    }
  }

  @override
  void dispose() {
    animationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: widget.speed,
      opacity: opacity ??
          (widget.blinking == BlinkerState.OFF
              ? widget.minOpacity
              : widget.maxOpacity),
      child: widget.child,
    );
  }
}
