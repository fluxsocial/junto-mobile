import 'package:flutter/material.dart';

class PageIndexProvider extends ChangeNotifier {
  int get collectivePageIndex => _collectivePageIndex ?? 0;
  int get packsPageIndex => _packsPageIndex ?? 0;

  int _collectivePageIndex;
  int _packsPageIndex;

  void setCollectivePageIndex(int index) {
    _collectivePageIndex = index;
    notifyListeners();
  }

  void setPacksPageIndex(int index) {
    _packsPageIndex = index;
    notifyListeners();
  }
}
