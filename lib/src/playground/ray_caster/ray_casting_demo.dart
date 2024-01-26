import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raycasting/src/boundary/boundary.dart';
import 'package:raycasting/src/boundary/line_boundary.dart';
import 'package:raycasting/src/playground/ray_caster/multi_ray_particle.dart';
import 'package:raycasting/src/particle.dart';
import 'package:raycasting/src/perlin_noise.dart';
import 'package:raycasting/src/playground/ray_caster/ray_casting_painter.dart';
import 'package:raycasting/src/point.dart';

class RayCastingDemo extends StatefulWidget {
  const RayCastingDemo({super.key});

  @override
  State<RayCastingDemo> createState() => _RayCastingDemoState();
}

class _RayCastingDemoState extends State<RayCastingDemo> {
  Particle? _particle;
  late final List<Boundary> _boundaries = [];

  List<Boundary> _getScreenBoundaries(double width, double height) {
    height = height * .885;
    return [
      LineBoundary(
        Point(0, 0, maxX: width, maxY: height),
        Point(width, 0, maxX: width, maxY: height),
        Colors.grey.shade900,
      ),
      LineBoundary(
        Point(width, 0, maxX: width, maxY: height),
        Point(width, height, maxX: width, maxY: height),
        Colors.grey.shade900,
      ),
      LineBoundary(
        Point(0, height, maxX: width, maxY: height),
        Point(width, height, maxX: width, maxY: height),
        Colors.grey.shade900,
      ),
      LineBoundary(
        Point(0, 0, maxX: width, maxY: height),
        Point(0, height, maxX: width, maxY: height),
        Colors.grey.shade900,
      ),
    ];
  }

  List<Boundary> _generateRandomBoundaries(double width, double height) {
    List<Boundary> boundaries = [];

    for (int i = 0; i < 6; i++) {
      boundaries.add(
        LineBoundary(
          Point.random(width, height),
          Point.random(width, height),
        ),
      );
    }

    return boundaries;
  }

  Timer? _timer;

  double _xOff = 0.1;
  double _yOff = 10000;

  Offset? _tapDownOffset;
  Offset? _tapUpOffset;

  bool _shouldRemoveLastBoundary = false;

  void _startAutoMovement(Size size) {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(milliseconds: 50),
      (timer) {
        if (_particle != null) {
          setState(() {
            _particle?.setParticlePosition(
              Point(noise(_xOff, _yOff) * 3, noise(_yOff, _xOff) * 3),
            );
            _xOff += 0.01;
            _yOff += 0.01;
            _particle = MultiRayParticle.fromPosition(_particle!.pos);
          });
        }
      },
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Welcome!"),
        content: Column(
          children: [
            const SizedBox(height: 12),
            Text(
              "Drag your finger across the screen to draw lines and 'box in' the ray.\n\nAt any point, you can click the plus icon at the top to generate random obstacles or the refresh icon to remove all obstacles on the screen.",
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
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    if (_particle == null) {
      Future.microtask(() {
        _particle = MultiRayParticle.fromPosition(
          const Point(200, 400),
        );

        _boundaries.addAll(_getScreenBoundaries(width, height));
        setState(() {});
        _startAutoMovement(MediaQuery.of(context).size);
      });
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Raycasting demo"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _boundaries.clear();
                _boundaries.addAll(_getScreenBoundaries(width, height));
                _boundaries.addAll(_generateRandomBoundaries(width, height));
              });
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _boundaries.clear();
                _boundaries.addAll(_getScreenBoundaries(width, height));
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Listener(
        onPointerMove: (details) {
          final offset = details.localPosition;
          if (_shouldRemoveLastBoundary) _boundaries.removeLast();
          _boundaries.add(LineBoundary(
            Point(
              _tapDownOffset!.dx,
              _tapDownOffset!.dy,
              maxX: width,
              maxY: height,
            ),
            Point(
              offset.dx,
              offset.dy,
              maxX: width,
              maxY: height,
            ),
          ));
          if (!_shouldRemoveLastBoundary) _shouldRemoveLastBoundary = true;
          setState(() {});
        },
        onPointerDown: (details) {
          _tapDownOffset = details.localPosition;
        },
        onPointerUp: (details) {
          _tapUpOffset = details.localPosition;

          if (_tapDownOffset != _tapUpOffset) {
            _boundaries.removeLast();
            _boundaries.add(
              LineBoundary(
                Point(
                  _tapDownOffset!.dx,
                  _tapDownOffset!.dy,
                  maxX: width,
                  maxY: height,
                ),
                Point(
                  _tapUpOffset!.dx,
                  _tapUpOffset!.dy,
                  maxX: width,
                  maxY: height,
                ),
              ),
            );
            setState(() {});
            _shouldRemoveLastBoundary = false;
          }

          _tapDownOffset = _tapUpOffset = null;
        },
        child: SizedBox.expand(
          child: Stack(
            children: [
              CustomPaint(
                painter: RayCastingPainter(_boundaries, _particle),
                size: MediaQuery.of(context).size,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
