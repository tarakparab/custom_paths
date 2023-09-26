import 'dart:math' as math;
import 'dart:ui';

class Line {
  Offset p1;
  Offset p2;
  double scale;

  Line({
    required this.p1,
    required this.p2,
    required this.scale,
  });

  double get x => p2.dx - p1.dx;
  double get y => p2.dy - p1.dy;
  Offset get centre => Offset.lerp(p1, p2, 0.5)!;

  double get length => (p1 - p2).distance;
  // math.sqrt(x * x + y * y);

  double get slope => y / x;
  double get inclination => math.atan2(y, x);

  // Normalised components
  double get ux => x / length;
  double get dy => y / length;

  Path get path {
    final path = Path();
    path.moveTo(p1.dx, p1.dy);
    path.lineTo(p2.dx, p2.dy);
    return path;
  }
}

class DashedLine extends Line {
  final double dashLength;
  final double spaceLength;
  DashedLine({
    required super.p1,
    required super.p2,
    this.dashLength = 12.0,
    this.spaceLength = 3.0,
    super.scale = 1,
  });

  // Segment properties
  double get _segmentLength => dashLength + spaceLength;
  int get _nrOfCompleteSegments => length ~/ _segmentLength;
  double get _totalLengthOfCompleteSegments =>
      _nrOfCompleteSegments * _segmentLength;

  // End fractional segment properties
  double get _endFractionLength => length - _totalLengthOfCompleteSegments;

  @override
  Path get path {
    final path = Path();
    double startX = p1.dx;
    double startY = p1.dy;

    // Create dashes
    for (var i = 0; i < _nrOfCompleteSegments; i++) {
      path.moveTo(startX, startY);
      final endX = startX + ux * dashLength;
      final endY = startY + dy * dashLength;
      path.lineTo(endX, endY);
      startX += ux * _segmentLength;
      startY += dy * _segmentLength;
    }

    // Create remaining fraction of dash
    path.moveTo(startX, startY);
    final endX = startX + ux * _endFractionLength;
    final endY = startY + dy * _endFractionLength;
    path.lineTo(endX, endY);

    return path;
  }
}

class DoubleDashedLine extends DashedLine {
  final double dash2Length;
  final double space1Length;
  final double? space2Length;
  DoubleDashedLine({
    required super.p1,
    required super.p2,
    super.dashLength = 24.0,
    this.dash2Length = 6.0,
    this.space1Length = 3.0,
    this.space2Length,
    super.scale = 1,
  }) : super(
            spaceLength:
                space1Length + dash2Length + (space2Length ?? space1Length));

  @override
  Path get path {
    final path = super.path;

    // Create dots
    final dash2Start = dashLength + space1Length;

    double startX = p1.dx + ux * dash2Start;
    double startY = p1.dy + dy * dash2Start;

    for (var i = 0; i < _nrOfCompleteSegments; i++) {
      path.moveTo(startX, startY);
      final endX = startX + ux * dash2Length;
      final endY = startY + dy * dash2Length;
      path.lineTo(endX, endY);
      startX += ux * _segmentLength;
      startY += dy * _segmentLength;
    }

    return path;
  }
}
