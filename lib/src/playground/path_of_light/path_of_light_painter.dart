import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:raycasting/src/boundary/boundary.dart';
import 'package:raycasting/src/particle.dart';
import 'package:raycasting/src/point.dart';

class PathOfLightPainter extends CustomPainter {
  final List<Boundary> _boundaries;
  final Particle? _particle;
  final Iterable<Point> _points;
  final Function(Point) _updatePoint;

  PathOfLightPainter(
    this._boundaries,
    this._particle,
    this._points,
    this._updatePoint,
  );

  late final _pointPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5
    ..color = Colors.pinkAccent;

  late final _rayPaint = Paint()
    ..strokeWidth = 1
    ..color = Colors.white.withOpacity(.5);

  late final _particlePaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.white;

  @override
  void paint(Canvas canvas, Size size) {
    if (_particle != null) {
      canvas.drawCircle(_particle!.pos.toOffset(), 10, _particlePaint);
    }

    for (var boundary in _boundaries) {
      boundary.draw(canvas);
    }

    if (_particle != null) {
      final rayIntersectionPoints = _particle!.getRayHits(_boundaries);

      if (rayIntersectionPoints.isNotEmpty) {
        _updatePoint(rayIntersectionPoints.first);
      } else {
        for (var ray in _particle!.rays) {
          canvas.save();
          canvas.translate(ray.pos.x.toDouble(), ray.pos.y.toDouble());
          canvas.drawLine(Offset.zero,
              ray.direction.scale(size.width, 10).toOffset(), _rayPaint);
          canvas.restore();
        }
      }

      for (var intersectionPoint in rayIntersectionPoints) {
        canvas.drawLine(
          _particle!.pos.toOffset(),
          intersectionPoint.toOffset(),
          _rayPaint,
        );
      }
    }

    canvas.drawPoints(
      PointMode.points,
      _points.map((e) => e.toOffset()).toList(),
      _pointPaint,
    );
  }

  @override
  bool shouldRepaint(covariant PathOfLightPainter oldDelegate) =>
      oldDelegate._boundaries != _boundaries ||
      oldDelegate._particle != _particle ||
      oldDelegate._points != _points;
}
