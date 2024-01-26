import 'package:flutter/material.dart';
import 'package:raycasting/src/boundary/boundary.dart';
import 'package:raycasting/src/point.dart';
import 'package:raycasting/src/ray.dart';

class PolygonBoundary implements Boundary {
  final List<Point> points;
  final Color lineColor;

  const PolygonBoundary(this.points, [this.lineColor = Colors.grey]);

  Paint get _paint {
    return Paint()
      ..strokeWidth = 1.5
      ..color = lineColor;
  }

  @override
  void draw(Canvas canvas) {
    if (points.isEmpty) return;

    Point last = points[0];
    Point next = points[1];
    int index = 1;

    while (true) {
      canvas.drawLine(
        last.toOffset(),
        next.toOffset(),
        _paint,
      );
      if (index <= points.length - 1) last = points[index];
      index++;
      if (index > points.length - 1) {
        next = points[0];
        canvas.drawLine(
          last.toOffset(),
          next.toOffset(),
          _paint,
        );
        break;
      } else {
        next = points[index];
      }
    }
  }

  ///Returns the intersection point (if any) where the [ray] hits
  ///a line drawn from [p1] to [p2].
  Point? _getIntersectionPointForLineSegment(Ray ray, Point p1, Point p2) {
    final x1 = p1.x;
    final y1 = p1.y;
    final x2 = p2.x;
    final y2 = p2.y;

    final x3 = ray.pos.x;
    final y3 = ray.pos.y;
    final x4 = ray.pos.x + ray.direction.x;
    final y4 = ray.pos.y + ray.direction.y;

    final denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);

    if (denominator == 0) return null;

    final t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denominator;
    final u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denominator;

    if (t > 0 && t < 1 && u > 0) {
      final x = x1 + t * (x2 - x1);
      final y = y1 + t * (y2 - y1);
      return Point(x, y);
    }

    return null;
  }

  ///Finds the intersection points where the ray
  ///hits all of the line segments in the polygon.
  @override
  List<Point> getIntersectionPoints(Ray ray) {
    if (points.isEmpty) return [];

    List<Point> intersectionPoints = [];

    Point p1 = points[0];
    Point p2 = points[1];
    int index = 1;

    while (true) {
      final point = _getIntersectionPointForLineSegment(ray, p1, p2);
      if (point != null) {
        intersectionPoints.add(point);
      }
      if (index <= points.length - 1) p1 = points[index];
      index++;
      if (index > points.length - 1) {
        p2 = points[0];
        final point = _getIntersectionPointForLineSegment(ray, p1, p2);
        if (point != null) {
          intersectionPoints.add(point);
        }
        break;
      } else {
        p2 = points[index];
      }
    }

    return intersectionPoints;
  }
}
