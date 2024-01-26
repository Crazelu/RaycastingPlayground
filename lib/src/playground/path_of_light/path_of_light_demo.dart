import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raycasting/src/boundary/boundary.dart';
import 'package:raycasting/src/boundary/polygon_boundary.dart';
import 'package:raycasting/src/playground/path_of_light/one_ray_particle.dart';
import 'package:raycasting/src/particle.dart';
import 'package:raycasting/src/playground/path_of_light/path_of_light_painter.dart';
import 'package:raycasting/src/point.dart';

///Traces points where ray hits polygons it moves across the canvas
class PathOfLightDemo extends StatefulWidget {
  const PathOfLightDemo({super.key});

  @override
  State<PathOfLightDemo> createState() => _PathOfLightDemoState();
}

class _PathOfLightDemoState extends State<PathOfLightDemo> {
  Particle? _particle;
  late final List<Boundary> _boundaries = [];
  late final Set<Point> _hitPoints = {};

  double _horizontalSliderValue = 0;
  static const double _scaleFactor = 1;
  static const double _maxSlideValue = 3;

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Welcome!"),
        content: Column(
          children: [
            const SizedBox(height: 12),
            Text(
              "Use the slider to move the ray across the screen.\n\nThe ray will paint a dot on any solid body it touches, hence, showing the path of light.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text("Got It"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_showInfoDialog);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    if (_particle == null) {
      Future.microtask(() {
        _particle = OneRayParticle.fromPosition(
          const Point(20, 30),
        );

        final boundaries = [
          //triangle
          const PolygonBoundary([
            Point(200, 140),
            Point(120, 190),
            Point(280, 190),
          ]),
          //top rectangle
          PolygonBoundary([
            Point(width * .88, 90),
            Point(width * .88, 250),
            Point(width * .69, 250),
            Point(width * .69, 90),
          ]),
          //parallelogram
          PolygonBoundary([
            Point(width * .58, 300),
            Point(width * .78, 300),
            Point(width * .38, 600),
            Point(width * .18, 600),
          ]),

          //bottom rectangle
          PolygonBoundary([
            Point(20, height * .7),
            Point(width * .4, height * .7),
            Point(width * .4, height * .8),
            Point(20, height * .8),
          ]),
        ];

        _boundaries.addAll(boundaries);

        setState(() {});
      });
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Path of light demo"),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            CustomPaint(
              painter: PathOfLightPainter(
                _boundaries,
                _particle,
                _hitPoints,
                (point) {
                  Future.microtask(() {
                    setState(() {
                      _hitPoints.add(point);
                    });
                  });
                },
              ),
              size: MediaQuery.of(context).size,
            ),
            Positioned(
              bottom: 20,
              left: 10,
              child: Slider(
                max: _maxSlideValue,
                value: _horizontalSliderValue,
                onChanged: (newValue) {
                  if (newValue > _horizontalSliderValue) {
                    _particle?.setParticlePosition(
                      Point(0,
                          (newValue - _horizontalSliderValue) * _scaleFactor),
                    );
                  } else {
                    double position = newValue - _horizontalSliderValue;

                    if (newValue == 0) {
                      position = -_horizontalSliderValue;
                    }
                    _particle?.setParticlePosition(
                      Point(0, position * _scaleFactor),
                    );
                  }
                  _horizontalSliderValue = newValue;
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
