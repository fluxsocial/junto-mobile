import 'package:flutter/material.dart';

import 'package:junto_beta_mobile/models/pack.dart';

class PacksProvider with ChangeNotifier {
  List _packs = Pack.fetchAll();

  List get packs {
    return _packs;
  }
}
