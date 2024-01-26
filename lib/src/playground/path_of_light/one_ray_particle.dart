import 'package:raycasting/src/boundary/boundary.dart';
import 'package:raycasting/src/particle.dart';
import 'package:raycasting/src/point.dart';
import 'package:raycasting/src/ray.dart';

class OneRayParticle implements Particle {
  final List<Ray> _rays;
  Point _pos;

  OneRayParticle(Point pos, this._rays) : _pos = pos;

  factory OneRayParticle.fromPosition(Point position) {
    return OneRayParticle(
      position,
      [Ray(angle: Particle.degToRad(0), pos: position)],
    );
  }

  @override
  Point get pos => _pos;

  @override
  List<Ray> get rays => _rays;

  @override
  List<Point> getRayHits(List<Boundary> boundaries) {
    List<Point> intersectionPointsWithBoundaries = [];
    for (var ray in rays) {
      List<Point> intersectionPointsWithBoundary = [];
      for (var boundary in boundaries) {
        intersectionPointsWithBoundary.addAll(ray.cast(boundary));
      }

      final closestPoint = _getClosestHitPointWithSameSlopeAsRay(
        intersectionPointsWithBoundary,
        ray,
      );
      if (closestPoint != null) {
        intersectionPointsWithBoundaries.add(closestPoint);
      }
    }

    print("POINTS: $intersectionPointsWithBoundaries");

    return intersectionPointsWithBoundaries;
  }

  Point? _getClosestHitPointWithSameSlopeAsRay(List<Point> points, Ray ray) {
    double minDistance = double.infinity;
    Point? closestPoint;

    final raySlope = ray.slope;
    print("RAY SLOPE -> $raySlope");

    for (var point in points) {
      if (raySlope == _calculateSlope(ray.pos, point)) {
        final distance = ray.pos.getDistance(point);
        if (distance < minDistance) {
          minDistance = distance;
          closestPoint = point;
        }
      }
    }

    return closestPoint;
  }

  double _calculateSlope(Point a, Point b) {
    return double.parse(((b.y - a.y) / (b.x - a.x)).toStringAsFixed(4));
  }

  @override
  void setParticlePosition(Point point) {
    _setAngleOfRays(point.y);
  }

  @override
  void setPositionOfRays(Point point) {
    for (var ray in rays) {
      ray.setPosition(point);
    }
  }

  void _setAngleOfRays(num angle) {
    for (var ray in rays) {
      ray.translateAngle(angle);
    }
  }
}
