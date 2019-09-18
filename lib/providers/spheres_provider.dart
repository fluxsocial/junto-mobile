import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/sphere.dart';

class SpheresProvider with ChangeNotifier {
  final List<Sphere> _spheres = Sphere.fetchAll();

  List<Sphere> get spheres {
    return _spheres;
  }
}
