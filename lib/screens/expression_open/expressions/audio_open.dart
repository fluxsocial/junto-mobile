import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/audio/audio_preview.dart';
import 'package:junto_beta_mobile/widgets/audio/audio_title.dart';
import 'package:provider/provider.dart';

class AudioOpen extends StatelessWidget {
  AudioOpen(this.expression);
  final ExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    final audio = expression.expressionData as AudioFormExpression;
    return ChangeNotifierProvider<AudioService>(
      create: (context) => AudioService()..initializeFromWeb(audio.audio),
      lazy: false,
      child: AudioOpenLayout(audio),
    );
  }
}

class AudioOpenLayout extends StatelessWidget {
  const AudioOpenLayout(
    this.audio, {
    Key key,
  }) : super(key: key);

  final AudioFormExpression audio;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (audio.photo.isEmpty) EmptyAudioBackground(),
        if (audio.photo.isNotEmpty)
          CachedNetworkImage(
            imageUrl: audio.photo,
          ),
        AudioBlackOverlay(),
        Positioned.fill(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: AudioPlayControls(audio: audio),
          ),
        ),
      ],
    );
  }
}

class AudioPlayControls extends StatelessWidget {
  const AudioPlayControls({
    Key key,
    @required this.audio,
  }) : super(key: key);

  final AudioFormExpression audio;

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audio, child) {
        if (audio.playBackAvailable) {
          return child;
        } else {
          return JuntoLoader();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (audio.title.isNotEmpty) AudioPreviewTitle(audio: audio),
          SizedBox(height: 16),
          AudioPlaybackRow(),
        ],
      ),
    );
  }
}
