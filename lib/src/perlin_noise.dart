import 'package:raycasting/src/point.dart';
import 'dart:math' as math;

///From https://rtouti.github.io/graphics/perlin-noise-algorithm#:~:text=Generally%2C%20in%20Perlin%20noise%20implementations,something%20called%20a%20permutation%20table.

const _numberOfPerms = 256;

void _shuffle(List<int> tab) {
  for (int e = tab.length - 1; e > 0; e--) {
    final index = (math.Random().nextDouble() * (e - 1)).round();
    int temp = tab[e];

    tab[e] = tab[index];
    tab[index] = temp;
  }
}

List<int> _makePermutations() {
  List<int> permutations = [];
  for (int i = 0; i < _numberOfPerms; i++) {
    permutations.add(i);
  }
  _shuffle(permutations);
  for (int i = 0; i < _numberOfPerms; i++) {
    permutations.add(permutations[i]);
  }

  return permutations;
}

List<int> _permutations = _makePermutations();

Point _getConstantVector(v) {
  //v is the value from the permutation table
  final h = v & 3;
  if (h == 0) {
    return const Point(1.0, 1.0);
  } else if (h == 1) {
    return const Point(-1.0, 1.0);
  } else if (h == 2) {
    return const Point(-1.0, -1.0);
  } else {
    return const Point(1.0, -1.0);
  }
}

num _fade(t) {
  return ((6 * t - 15) * t + 10) * t * t * t;
}

double _lerp(t, a1, a2) {
  return a1 + t * (a2 - a1);
}

double noise(double x, double y) {
  final X = x.floor() & _numberOfPerms - 1;
  final Y = y.floor() & _numberOfPerms - 1;

  final xf = x - x.floor();
  final yf = y - y.floor();

  final topRight = Point(xf - 1.0, yf - 1.0);
  final topLeft = Point(xf, yf - 1.0);
  final bottomRight = Point(xf - 1.0, yf);
  final bottomLeft = Point(xf, yf);

  //Select a value in the array for each of the 4 corners
  final valueTopRight = _permutations[_permutations[X + 1] + Y + 1];
  final valueTopLeft = _permutations[_permutations[X] + Y + 1];
  final valueBottomRight = _permutations[_permutations[X + 1] + Y];
  final valueBottomLeft = _permutations[_permutations[X] + Y];

  final dotTopRight = topRight.dot(_getConstantVector(valueTopRight));
  final dotTopLeft = topLeft.dot(_getConstantVector(valueTopLeft));
  final dotBottomRight = bottomRight.dot(_getConstantVector(valueBottomRight));
  final dotBottomLeft = bottomLeft.dot(_getConstantVector(valueBottomLeft));

  final u = _fade(xf);
  final v = _fade(yf);

  return _lerp(
    u,
    _lerp(v, dotBottomLeft, dotTopLeft),
    _lerp(v, dotBottomRight, dotTopRight),
  );
}
