import 'package:flutter/material.dart';
import 'dart:math' as math;

class Point {
  final num x;
  final num y;
  final num maxX;
  final num maxY;

  const Point(
    this.x,
    this.y, {
    this.maxX = double.infinity,
    this.maxY = double.infinity,
  });

  factory Point.fromAngle(num angle) {
    return Point(
      math.cos(angle),
      math.sin(angle),
    );
  }

  static Point zero = const Point(0, 0);

  factory Point.random(double seedX, double seedY) {
    return Point(
      math.Random().nextInt(seedX.toInt()),
      math.Random().nextInt(seedY.toInt()),
      maxX: seedX,
      maxY: seedY,
    );
  }

  Point copyWith({num? x, num? y}) => Point(
        x ?? this.x,
        y ?? this.y,
        maxX: maxX,
        maxY: maxY,
      );

  double getDistance(Point point) {
    final dx = (x - point.x) * (x - point.x);
    final dy = (y - point.y) * (y - point.y);

    return math.sqrt(dx + dy);
  }

  num dot(Point other) {
    return x * other.x + y * other.y;
  }

  Point translate(num translateX, num translateY) {
    return Point(
      math.min(maxX, math.max(0, x + translateX)),
      math.min(maxY, math.max(0, y + translateY)),
      maxX: maxX,
      maxY: maxY,
    );
  }

  Point scale(num scaleX, num scaleY) {
    return Point(
      x * scaleX,
      y * scaleY,
      maxX: maxX,
      maxY: maxY,
    );
  }

  Offset toOffset() => Offset(x.toDouble(), y.toDouble());

  @override
  bool operator ==(Object other) {
    return other is Point && other.x == x && other.y == y;
  }

  @override
  int get hashCode => Object.hashAll([x, y]);

  @override
  String toString() => "Point($x, $y)";
}
