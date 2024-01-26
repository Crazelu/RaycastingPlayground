import 'package:raycasting/src/boundary/boundary.dart';
import 'package:raycasting/src/point.dart';
import 'dart:math' as math;

class Ray {
  Point _pos;
  Point _direction;

  Point get pos => _pos;
  Point get direction => _direction;

  Ray({
    required num angle,
    required Point pos,
  })  : _pos = pos,
        _direction = Point.fromAngle(angle);

  void setPosition(Point newPos) {
    _pos = _pos.translate(newPos.x, newPos.y);
  }

  void translateAngle(num angle) {
    final oldAngle = math.acos(_direction.x);
    _direction = Point.fromAngle(oldAngle + angle);
  }

  double get slope {
    return double.parse(math.tan(math.acos(_direction.x)).toStringAsFixed(4));
  }

  List<Point> cast(Boundary boundary) => boundary.getIntersectionPoints(this);

  @override
  bool operator ==(Object other) {
    return other is Ray && other._direction == _direction && other._pos == _pos;
  }

  @override
  int get hashCode => Object.hashAll([_pos, _direction]);
}
