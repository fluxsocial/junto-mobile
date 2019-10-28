import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';

class JuntoStyles {
  // horizontal padding for widgets across app
  static const double horizontalPadding = 10.0;

  // icon size used across appbars
  static const double appbarIcon = 20.0;

  // title style used across appbars
  static const TextStyle appbarTitle = TextStyle(
    color: JuntoPalette.juntoSleek,
    fontSize: 15,
    letterSpacing: .5,
    fontWeight: FontWeight.w700,
  );

  // title style used across display names, sphere/pack titles, etc.
  static const TextStyle header = TextStyle(
    color: JuntoPalette.juntoGrey,
    fontSize: 17,
    fontWeight: FontWeight.w700,
  );

  // title style used across display names, sphere/pack titles, etc.
  static const TextStyle title = TextStyle(
    color: JuntoPalette.juntoGrey,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  // default text style across app
  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: JuntoPalette.juntoGrey,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle expressionTimestamp = TextStyle(
    fontSize: 12,
    color: JuntoPalette.juntoGreyLight,
    fontWeight: FontWeight.w600,
  );

  // title style used in longform expression preview
  static const TextStyle longformPreviewTitle = TextStyle(
    color: JuntoPalette.juntoGrey,
    fontSize: 17,
    fontWeight: FontWeight.w700,
  );

  // body style used in longform expression preview
  static const TextStyle longformPreviewBody = TextStyle(
    height: 1.25,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    color: JuntoPalette.juntoGrey,
  );

  // title style used in shortform expression preview
  static const TextStyle shortformPreviewTitle = TextStyle(
    color: JuntoPalette.juntoWhite,
    fontSize: 17,
    fontWeight: FontWeight.w700,
  );

  // Text Field style for filtering by channels
  static const TextStyle filterChannelText =
      TextStyle(fontSize: 14, color: JuntoPalette.juntoGrey);

  static const TextStyle lotusLongformBody = TextStyle(
    height: 1.25,
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Avenir Heavy',
    color: JuntoPalette.juntoGrey,
  );

  static const TextStyle perspectiveTitle = TextStyle(
    color: JuntoPalette.juntoGrey,
    fontWeight: FontWeight.w700,
    fontFamily: 'Avenir',
  );
}
