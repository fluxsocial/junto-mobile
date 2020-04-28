import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/widgets/audio/audio_gradient_background.dart';
import 'package:junto_beta_mobile/widgets/audio/audio_title.dart';

class CommonAudioPreview extends StatelessWidget {
  final ExpressionResponse expression;

  const CommonAudioPreview({
    Key key,
    @required this.expression,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audio = expression.expressionData as AudioFormExpression;

    return AspectRatio(
      aspectRatio: 3 / 2,
      child: AudioGradientBackground(
        audio: audio,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (audio.photo != null && audio.photo.isNotEmpty)
              Positioned.fill(
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: audio.photo,
                        placeholder: (BuildContext context, String _) {
                          return Container(
                            color: Theme.of(context).dividerColor,
                          );
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(child: Container(color: Colors.black38)),
                  ],
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                if (audio.title.isNotEmpty) AudioPreviewTitle(audio: audio),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
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
      ),
    );
  }
}
