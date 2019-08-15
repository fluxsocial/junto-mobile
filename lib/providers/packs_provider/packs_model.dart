
import 'package:flutter/material.dart';

class Collective with ChangeNotifier {
  List _packs = []; 

  List get packs {
    return [..._packs]; 
  }

}