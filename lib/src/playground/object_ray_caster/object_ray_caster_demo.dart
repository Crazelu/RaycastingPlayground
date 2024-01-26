import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raycasting/src/playground/object_ray_caster/model/object_model.dart';
import 'package:raycasting/src/playground/object_ray_caster/object_ray_caster_painter.dart';
import 'package:raycasting/src/playground/object_ray_caster/object_ray_caster_particle.dart';
import 'package:raycasting/src/particle.dart';
import 'package:raycasting/src/point.dart';

///Draws intersection points between ray(s) and object model geometries
///in order to draw object graphically on screen.
class ObjectRayCasterDemo extends StatefulWidget {
  const ObjectRayCasterDemo({
    super.key,
    required this.model,
    this.title = 'Object Raycasting Demo',
  });

  final ObjectModel model;
  final String title;

  @override
  State<ObjectRayCasterDemo> createState() => _ObjectRayCasterDemoState();
}

class _ObjectRayCasterDemoState extends State<ObjectRayCasterDemo> {
  Particle? _particle;
  late final Set<Point> _hitPoints = {};

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Welcome!"),
        content: Column(
          children: [
            const SizedBox(height: 12),
            Text(
              "Move the ray around to reveal the object beneath.",
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
        _particle = CarRayCasterParticle.fromPosition(
          const Point(200, 100),
        );

        setState(() {});
      });
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Listener(
        onPointerMove: (event) {
          final offset = event.localPosition;
          setState(() {
            _particle?.setParticlePosition(
              Point(
                offset.dx - _particle!.pos.x,
                offset.dy - _particle!.pos.y,
                maxX: width,
                maxY: height,
              ),
            );
            _particle = CarRayCasterParticle.fromPosition(_particle!.pos);
          });
        },
        child: SizedBox.expand(
          child: CustomPaint(
            painter: ObjectRayCasterPainter(
              widget.model,
              _particle,
              _hitPoints,
              (points) {
                Future.microtask(() {
                  setState(() {
                    _hitPoints.addAll(points);
                  });
                });
              },
            ),
            size: MediaQuery.of(context).size,
          ),
        ),
      ),
    );
  }
}
