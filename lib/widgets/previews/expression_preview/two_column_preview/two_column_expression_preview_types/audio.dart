import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AudioPreview extends StatelessWidget {
  AudioPreview({@required this.expression});
  final ExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    final audioTitle = expression.expressionData.title;
    final audioGradients = expression.expressionData.gradient;
    final audioPhoto = expression.expressionData.photo;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.black38,
              BlendMode.srcOver,
            ),
            image: NetworkImage(
              audioPhoto,
            ),
            fit: BoxFit.cover,
          ),
        ),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * .24,
        ),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
          vertical: 50.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                audioTitle,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: audioGradients.isNotEmpty || audioPhoto.isNotEmpty
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
              ),
            ),
            Image.asset(
              'assets/images/junto-mobile__waveform.png',
              height: 38,
              color: audioGradients.isNotEmpty || audioPhoto.isNotEmpty
                  ? Colors.white
                  : Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
