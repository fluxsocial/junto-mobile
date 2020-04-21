import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';

class CommonAudioPreview extends StatelessWidget {
  final ExpressionResponse expression;

  const CommonAudioPreview({
    Key key,
    @required this.expression,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audio = expression.expressionData as AudioFormExpression;
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
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          if (audio.photo != null && audio.photo.isNotEmpty)
            Container(
              width: MediaQuery.of(context).size.width,
              child: CachedNetworkImage(
                imageUrl: audio.photo,
                placeholder: (BuildContext context, String _) {
                  return Container(
                    color: Theme.of(context).dividerColor,
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                  );
                },
                fit: BoxFit.cover,
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (audio.title.isNotEmpty) AudioPreviewTitle(audio: audio),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Icon(
                  Icons.play_arrow,
                  size: 33,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AudioPreviewTitle extends StatelessWidget {
  const AudioPreviewTitle({
    Key key,
    @required this.audio,
  }) : super(key: key);

  final AudioFormExpression audio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 8.0,
        right: 8.0,
      ),
      child: Text(
        audio.title,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
