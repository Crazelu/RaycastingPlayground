import 'package:raycasting/src/boundary/boundary.dart';
import 'package:raycasting/src/ray.dart';
import 'package:raycasting/src/point.dart';
import 'dart:math' as math;

abstract class Particle {
  List<Ray> get rays;
  Point get pos;
  void setParticlePosition(Point point);
  void setPositionOfRays(Point point);
  List<Point> getRayHits(List<Boundary> boundaries);

  static num degToRad(num deg) {
    return deg * (math.pi / 180);
  }

  @override
  bool operator ==(Object other) {
    return other is Particle && other.pos == pos && other.rays == rays;
  }

  @override
  int get hashCode => Object.hashAll([pos, rays]);
}
