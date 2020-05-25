import 'package:flutter/material.dart';

class PageIndexProvider extends ChangeNotifier {
  int get collectivePageIndex => _collectivePageIndex ?? 0;
  int _collectivePageIndex;

  void setCollectivePageIndex(int index) {
    _collectivePageIndex = index;
    print(_collectivePageIndex);
    notifyListeners();
  }
}
