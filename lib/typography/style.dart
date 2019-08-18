import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/typography/palette.dart';

// Misc notes

// // horizontal app padding = 12.0
// // expression preview profile photo height and width = 36.0

class JuntoStyles {
  // Global Stles
  static const EdgeInsets horizontalPadding = EdgeInsets.symmetric(
    horizontal: 10,
  );

  // Styles for app bar
  static const TextStyle appbarTitle = TextStyle(
    color: JuntoPalette.juntoSleek,
    fontSize: 17,
    letterSpacing: .5,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle perspectiveTitle = TextStyle(
    color: JuntoPalette.juntoGrey,
    fontWeight: FontWeight.w700,
  );

  // Styles for creation templates
  static const TextStyle lotusExpressionType = TextStyle(
    fontSize: 17,
    color: JuntoPalette.juntoGrey,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.1,
  );

  static const TextStyle lotusAddChannels = TextStyle(
    fontWeight: FontWeight.w700,
  );

  static const TextStyle lotusCreate = TextStyle(
    fontWeight: FontWeight.w700,
  );

  // Longform styles
  static const TextStyle lotusLongformTitle = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w700,
    color: JuntoPalette.juntoGrey,
  );

  static const TextStyle lotusLongformBody = TextStyle(
    height: 1.25,
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    color: JuntoPalette.juntoGrey,
  );

  // Styles for expression preview

  static const TextStyle expressionPreviewName = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w700,
    color: JuntoPalette.juntoGrey,
  );

  static const TextStyle expressionPreviewHandle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: JuntoPalette.juntoGrey,
  );

  static const TextStyle expressionPreviewTime = TextStyle(
    fontSize: 10,
    color: Colors.grey,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle expressionPreviewChannel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: JuntoPalette.juntoSleek,
  );

  // // longform preview
  static const TextStyle longformTitle = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w700,
    color: JuntoPalette.juntoGrey,
  );

  static const TextStyle longformBody = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: JuntoPalette.juntoGrey,
  );

  // // photo preview
  static const TextStyle photoCaption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}
