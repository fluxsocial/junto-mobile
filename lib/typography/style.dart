import 'package:flutter/material.dart';

import './palette.dart';

class JuntoStyles {
  // Styles for app bar
  static const appbarTitle = TextStyle(
      color: JuntoPalette.juntoSleek,
      fontWeight: FontWeight.w700,
      letterSpacing: 1);

  static const perspectiveTitle =
      TextStyle(color: JuntoPalette.juntoGrey, fontWeight: FontWeight.w700);

  // Styles for expression preview
  static const expressionPreviewName =
      TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700);

  static const expressionPreviewHandle =
      TextStyle(fontWeight: FontWeight.w500);      
}
