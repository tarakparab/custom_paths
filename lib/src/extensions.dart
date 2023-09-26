import 'dart:math' as math;

import 'package:flutter/rendering.dart';

extension Rotate on Offset {
  /// [angle] in radians clockwise
  Offset rotate(Offset pivot, double angle) {
    final delta = this - pivot;
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    return pivot +
        Offset(
          delta.dx * cos,
          delta.dx * sin,
        ) +
        Offset(
          -delta.dy * sin,
          delta.dy * cos,
        );
  }
}
