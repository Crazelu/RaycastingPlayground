import 'package:raycasting/src/boundary/boundary.dart';
import 'package:raycasting/src/particle.dart';
import 'package:raycasting/src/point.dart';
import 'package:raycasting/src/ray.dart';

class CarRayCasterParticle implements Particle {
  final List<Ray> _rays;
  Point _pos;

  CarRayCasterParticle(Point pos, this._rays) : _pos = pos;

  factory CarRayCasterParticle.fromPosition(Point position) {
    List<Ray> result = [];

    for (double i = 0; i < 360; i += 1.5) {
      result.add(Ray(angle: Particle.degToRad(i), pos: position));
    }

    return CarRayCasterParticle(position, result);
  }

  @override
  Point get pos => _pos;

  @override
  List<Ray> get rays => _rays;

  @override
  List<Point> getRayHits(List<Boundary> boundaries) {
    List<Point> points = [];
    for (var ray in rays) {
      Point? closestHitPoint;
      double minDistance = double.infinity;

      for (var boundary in boundaries) {
        final points = ray.cast(boundary);
        if (points.isNotEmpty) {
          final distance = _pos.getDistance(points.first);
          if (distance < minDistance) {
            minDistance = distance;
            closestHitPoint = points.first;
          }
        }
      }

      if (closestHitPoint != null) {
        points.add(closestHitPoint);
      }
    }
    return points;
  }

  @override
  void setParticlePosition(Point point) {
    _pos = _pos.translate(point.x, point.y);
    setPositionOfRays(point);
  }

  @override
  void setPositionOfRays(Point point) {
    for (var ray in rays) {
      ray.setPosition(point);
    }
  }

  @override
  bool operator ==(Object other) {
    return other is Particle && other.pos == pos && other.rays == rays;
  }

  @override
  int get hashCode => Object.hashAll([pos, rays]);
}
