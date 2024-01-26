import 'package:flutter/material.dart';
import 'package:raycasting/src/boundary/boundary.dart';

abstract class ObjectModel {
  ///Boundaries this object is comprised of
  List<Boundary> get boundaries;

  ///Draws object specified in this model on the [canvas]
  void draw(Canvas canvas);
}
