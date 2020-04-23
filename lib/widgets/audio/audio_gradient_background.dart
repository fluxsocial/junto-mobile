import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';

class AudioGradientBackground extends StatelessWidget {
  final Widget child;
  final AudioFormExpression audio;

  const AudioGradientBackground({Key key, this.child, this.audio})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final gradientOne = audio.gradient.isNotEmpty && audio.gradient.length > 1
        ? audio.gradient[0]
        : '#8E8098';
    final gradientTwo = audio.gradient.isNotEmpty && audio.gradient.length > 1
        ? audio.gradient[1]
        : '#307FAA';
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: const <double>[0.1, 0.9],
          colors: <Color>[
            HexColor.fromHex(gradientOne),
            HexColor.fromHex(gradientTwo)
          ],
        ),
      ),
      child: child,
    );
  }
}
