import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/pack.dart';

class PacksProvider with ChangeNotifier {
  final List<Pack> _packs = Pack.fetchAll();

  List<Pack> get packs {
    return _packs;
  }
}
