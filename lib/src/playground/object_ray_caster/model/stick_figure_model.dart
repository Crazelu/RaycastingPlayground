import 'package:flutter/material.dart';
import 'package:raycasting/src/boundary/boundary.dart';
import 'package:raycasting/src/boundary/line_boundary.dart';
import 'package:raycasting/src/boundary/polygon_boundary.dart';
import 'package:raycasting/src/playground/object_ray_caster/model/object_model.dart';

import 'package:raycasting/src/point.dart';

class StickFigureModel implements ObjectModel {
  StickFigureModel() : _boundaries = _generateBoundaries();

  static List<Boundary> _generateBoundaries() {
    const xScale = 50;
    const yScale = 100;

    return [
      //head
      const PolygonBoundary(
        [
          Point(100 + xScale, 120 + yScale),
          Point(160 + xScale, 120 + yScale),
          Point(160 + xScale, 170 + yScale),
          Point(100 + xScale, 170 + yScale),
        ],
        Colors.transparent,
      ),

      //left eye
      const PolygonBoundary(
        [
          Point(112 + xScale, 130 + yScale),
          Point(117 + xScale, 130 + yScale),
          Point(117 + xScale, 135 + yScale),
          Point(112 + xScale, 135 + yScale),
        ],
        Colors.transparent,
      ),

      //right eye
      const PolygonBoundary(
        [
          Point(143 + xScale, 130 + yScale),
          Point(148 + xScale, 130 + yScale),
          Point(148 + xScale, 135 + yScale),
          Point(143 + xScale, 135 + yScale),
        ],
        Colors.transparent,
      ),

      //nose
      const PolygonBoundary(
        [
          Point(130 + xScale, 142 + yScale),
          Point(125 + xScale, 147 + yScale),
          Point(135 + xScale, 147 + yScale),
        ],
        Colors.transparent,
      ),

      //mouth
      const PolygonBoundary(
        [
          Point(120 + xScale, 158 + yScale),
          Point(140 + xScale, 158 + yScale),
          Point(140 + xScale, 163 + yScale),
          Point(120 + xScale, 163 + yScale),
        ],
        Colors.transparent,
      ),

      //neck
      const LineBoundary(
        Point(130 + xScale, 170 + yScale),
        Point(130 + xScale, 420 + yScale),
        Colors.transparent,
      ),

      //left hand
      const LineBoundary(
        Point(130 + xScale, 220 + yScale),
        Point(50 + xScale, 280 + yScale),
        Colors.transparent,
      ),
      //left hand digits
      const LineBoundary(
        Point(58 + xScale, 275 + yScale),
        Point(42 + xScale, 270 + yScale),
        Colors.transparent,
      ),
      const LineBoundary(
        Point(58 + xScale, 275 + yScale),
        Point(58 + xScale, 290 + yScale),
        Colors.transparent,
      ),

      //right hand
      const LineBoundary(
        Point(130 + xScale, 220 + yScale),
        Point(210 + xScale, 280 + yScale),
        Colors.transparent,
      ),

      //right hand digits
      const LineBoundary(
        Point(218 + xScale, 275 + yScale),
        Point(202 + xScale, 275 + yScale),
        Colors.transparent,
      ),
      const LineBoundary(
        Point(200 + xScale, 290 + yScale),
        Point(200 + xScale, 272 + yScale),
        Colors.transparent,
      ),

      //left foot
      const LineBoundary(
        Point(130 + xScale, 420 + yScale),
        Point(50 + xScale, 480 + yScale),
        Colors.transparent,
      ),

      //right foot
      const LineBoundary(
        Point(130 + xScale, 420 + yScale),
        Point(210 + xScale, 480 + yScale),
        Colors.transparent,
      ),
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
