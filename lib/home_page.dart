import 'package:flutter/material.dart';
import 'package:raycasting/src/playground/object_ray_caster/model/car_model.dart';
import 'package:raycasting/src/playground/object_ray_caster/model/stick_figure_model.dart';
import 'package:raycasting/src/playground/object_ray_caster/object_ray_caster_demo.dart';
import 'package:raycasting/src/playground/path_of_light/path_of_light_demo.dart';
import 'package:raycasting/src/playground/ray_caster/ray_casting_demo.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Raycasting Playground"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _PageButton(
            title: "Raycasting Demo",
            page: RayCastingDemo(),
          ),
          const _PageButton(
            title: "Path of Light Demo",
            page: PathOfLightDemo(),
          ),
          _PageButton(
            title: "Car Raycasting Demo",
            page: ObjectRayCasterDemo(
              model: CarModel(),
              title: "Car Raycasting Demo",
            ),
          ),
          _PageButton(
            title: "Stick Figure Raycasting Demo",
            page: ObjectRayCasterDemo(
              model: StickFigureModel(),
              title: "Stick Figure Raycasting Demo",
            ),
          ),
        ],
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    super.key,
    required this.title,
    required this.page,
  });

  final String title;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => page,
          ),
        );
      },
      child: Text(title),
    );
  }
}
