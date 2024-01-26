import 'package:flutter/material.dart';
import 'package:raycasting/src/boundary/boundary.dart';
import 'package:raycasting/src/boundary/line_boundary.dart';
import 'package:raycasting/src/boundary/semi_circle_boundary.dart';
import 'package:raycasting/src/playground/object_ray_caster/model/object_model.dart';
import 'package:raycasting/src/point.dart';

class CarModel implements ObjectModel {
  CarModel() : _boundaries = _generateBoundaries();

  static List<Boundary> _generateBoundaries() {
    const xScale = 50;
    const yScale = 100;
    const double wheelRadius = 20;
    return [
      //roof
      const LineBoundary(
        Point(120 + xScale, 150 + yScale),
        Point(220 + xScale, 150 + yScale),
        Colors.transparent,
      ),
      //front window
      const LineBoundary(
        Point(120 + xScale, 150 + yScale),
        Point(80 + xScale, 180 + yScale),
        Colors.transparent,
      ),
      //bonnet
      const LineBoundary(
        Point(80 + xScale, 180 + yScale),
        Point(40 + xScale, 180 + yScale),
        Colors.transparent,
      ),
      //front light part
      const LineBoundary(
        Point(40 + xScale, 180 + yScale),
        Point(40 + xScale, 220 + yScale),
        Colors.transparent,
      ),

      //back window
      const LineBoundary(
        Point(220 + xScale, 150 + yScale),
        Point(240 + xScale, 180 + yScale),
        Colors.transparent,
      ),
      //boot part
      const LineBoundary(
        Point(240 + xScale, 180 + yScale),
        Point(290 + xScale, 180 + yScale),
        Colors.transparent,
      ),
      //tail light part
      const LineBoundary(
        Point(290 + xScale, 180 + yScale),
        Point(290 + xScale, 220 + yScale),
        Colors.transparent,
      ),

      //bottom segment

      //front side
      const LineBoundary(
        Point(40 + xScale, 220 + yScale),
        Point(80 + xScale, 220 + yScale),
        Colors.transparent,
      ),
      //back side
      const LineBoundary(
        Point(290 + xScale, 220 + yScale),
        Point(230 + wheelRadius + xScale, 220 + yScale),
        Colors.transparent,
      ),
      //front wheel
      const SemiCircleBoudnary(
        Point(80 + xScale, 220 + yScale),
        Point(100 + xScale, 220 + yScale),
        wheelRadius,
        Colors.transparent,
      ),
      //mid line
      const LineBoundary(
        Point(100 + wheelRadius + xScale, 220 + yScale),
        Point(210 + xScale, 220 + yScale),
        Colors.transparent,
      ),
      //rear wheel
      const SemiCircleBoudnary(
        Point(210 + xScale, 220 + yScale),
        Point(230 + xScale, 220 + yScale),
        wheelRadius,
        Colors.transparent,
      )
    ];
  }

  late final List<Boundary> _boundaries;

  @override
  List<Boundary> get boundaries => _boundaries;

  @override
  void draw(Canvas canvas) {
    for (var boundary in boundaries) {
      boundary.draw(canvas);
    }
  }
}
