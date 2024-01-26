import 'package:flutter/material.dart';
import 'package:raycasting/src/ray.dart';
import 'package:raycasting/src/point.dart';

abstract class Boundary {
  void draw(Canvas canvas);
  List<Point> getIntersectionPoints(Ray ray);
}
