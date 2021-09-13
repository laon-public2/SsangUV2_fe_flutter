import 'package:flutter/material.dart';

class PageTransitioned<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Curve curves;
  final Duration duration;
  final Duration durationRev;

  PageTransitioned({
    this.child,
    @required this.curves,
    @required this.duration,
    this.durationRev,
    RouteSettings settings,
  }): super(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = curves;

            var tween = Tween(begin: begin, end: end);
            var curvedAnimation = CurvedAnimation(
              parent: anim,
              curve: curve,
            );

            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          },
          reverseTransitionDuration: durationRev,
          transitionDuration: duration,
        );
}