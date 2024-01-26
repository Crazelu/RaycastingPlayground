import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  runApp(const RaycastingPlaygroundApp());
}

class RaycastingPlaygroundApp extends StatelessWidget {
  const RaycastingPlaygroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raycasting Playground',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
