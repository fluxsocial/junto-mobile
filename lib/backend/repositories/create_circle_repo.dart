import 'dart:io';

import 'package:flutter/cupertino.dart';

class CreateCircleRepo extends ChangeNotifier {
  ValueNotifier<File> imageFile = ValueNotifier<File>(null);
  int currentIndex = 0;
  String sphereName = "";
  String sphereHandle = "";
  String sphereDescription = "";

  void setPageIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void setSphereName(String name) {
    sphereName = name;
    notifyListeners();
  }

  void setSphereDescription(String description) {
    sphereDescription = description;
    notifyListeners();
  }

  void setSphereHandle(String handle) {
    sphereHandle = handle;
    notifyListeners();
  }

  void setImage(File file) {
    imageFile.value = file;
    notifyListeners();
  }

  void clear() {
    imageFile.value = null;
    sphereName = "";
    sphereDescription = "";
    sphereHandle = "";
    notifyListeners();
  }
}
