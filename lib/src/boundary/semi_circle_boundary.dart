import 'package:flutter/material.dart';
import 'package:raycasting/src/boundary/boundary.dart';
import 'package:raycasting/src/ray.dart';
import 'package:raycasting/src/point.dart';

class SemiCircleBoudnary implements Boundary {
  final Point p1;
  final Point p2;
  final double radius;
  final Color lineColor;

  const SemiCircleBoudnary(
    this.p1,
    this.p2,
    this.radius, [
    this.lineColor = Colors.white,
  ]);

  Paint get _getBoundaryPaint {
    return Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..color = lineColor;
  }

  @override
  void draw(Canvas canvas) {
    final path = Path();
    final p1X = p1.x.toDouble();
    final p1Y = p1.y.toDouble();

    path.moveTo(p1X, p1Y);
    path.arcToPoint(
      Offset(p1X + radius, p1Y - radius),
      radius: Radius.circular(radius),
    );
    path.arcToPoint(
      Offset(p1X + radius * 2, p2.y.toDouble()),
      radius: Radius.circular(radius),
    );

    canvas.drawPath(path, _getBoundaryPaint);
  }

  @override
  List<Point> getIntersectionPoints(Ray ray) {
    return [];
  }
}
