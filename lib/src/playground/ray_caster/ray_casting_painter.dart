import 'package:flutter/material.dart';
import 'package:raycasting/src/boundary/boundary.dart';
import 'package:raycasting/src/particle.dart';

class RayCastingPainter extends CustomPainter {
  final List<Boundary> _boundaries;
  final Particle? _particle;

  RayCastingPainter(this._boundaries, this._particle);

  late final _rayPaint = Paint()
    ..strokeWidth = 2
    ..color = Colors.grey.shade700;

  late final _pointPaint = Paint()
    ..strokeWidth = 1
    ..color = Colors.white.withOpacity(.5);

  late final _particlePaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.red;

  @override
  void paint(Canvas canvas, Size size) {
    if (_particle != null) {
      canvas.drawCircle(_particle!.pos.toOffset(), 10, _particlePaint);

      for (var ray in _particle!.rays) {
        canvas.save();
        canvas.translate(ray.pos.x.toDouble(), ray.pos.y.toDouble());
        canvas.drawLine(
            Offset.zero, ray.direction.scale(10, 10).toOffset(), _rayPaint);
        canvas.restore();
      }
    }

    for (var boundary in _boundaries) {
      boundary.draw(canvas);
    }

    if (_particle != null) {
      final particlePoints = _particle!.getRayHits(_boundaries);
      for (var point in particlePoints) {
        canvas.drawLine(
            _particle!.pos.toOffset(), point.toOffset(), _pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant RayCastingPainter oldDelegate) =>
      oldDelegate._boundaries != _boundaries ||
      oldDelegate._particle != _particle;
}
