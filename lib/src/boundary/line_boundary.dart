import 'package:flutter/material.dart';
import 'package:raycasting/src/boundary/boundary.dart';
import 'package:raycasting/src/ray.dart';
import 'package:raycasting/src/point.dart';

class LineBoundary implements Boundary {
  final Point p1;
  final Point p2;
  final Color lineColor;

  const LineBoundary(this.p1, this.p2, [this.lineColor = Colors.white]);

  Paint get _getBoundaryPaint {
    return Paint()
      ..strokeWidth = 2
      ..color = lineColor;
  }

  @override
  void draw(Canvas canvas) {
    canvas.drawLine(
      p1.toOffset(),
      p2.toOffset(),
      _getBoundaryPaint,
    );
  }

  ///Finds the intersection point between
  ///the line segment (LineBoundary) and the ray
  @override
  List<Point> getIntersectionPoints(Ray ray) {
    final x1 = p1.x;
    final y1 = p1.y;
    final x2 = p2.x;
    final y2 = p2.y;

    final x3 = ray.pos.x;
    final y3 = ray.pos.y;
    final x4 = ray.pos.x + ray.direction.x;
    final y4 = ray.pos.y + ray.direction.y;

    final denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);

    if (denominator == 0) return [];

    final t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denominator;
    final u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denominator;

    if (t > 0 && t < 1 && u > 0) {
      final x = x1 + t * (x2 - x1);
      final y = y1 + t * (y2 - y1);
      return [Point(x, y)];
    }

    return [];
  }
}
