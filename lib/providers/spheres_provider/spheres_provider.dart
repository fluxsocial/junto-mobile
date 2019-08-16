import 'package:flutter/material.dart';

import 'package:junto_beta_mobile/models/sphere.dart';

class SpheresProvider with ChangeNotifier {
  List _spheres = Sphere.fetchAll();

  List get spheres {
    return _spheres;
  }
}
