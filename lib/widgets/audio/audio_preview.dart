import 'dart:io';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:provider/provider.dart';

import 'audio_play.dart';
import 'audio_position.dart';
import 'audio_seek.dart';

class AudioBlackOverlay extends StatelessWidget {
  const AudioBlackOverlay({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 2 / 3,
      color: Colors.black38,
    );
  }
}

class PhotoAudioBackground extends StatelessWidget {
  const PhotoAudioBackground({
    Key key,
    @required this.audioPhotoBackground,
  }) : super(key: key);

  final File audioPhotoBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 2 / 3,
      child: Image.file(
        audioPhotoBackground,
        fit: BoxFit.cover,
      ),
    );
  }
}

class EmptyAudioBackground extends StatelessWidget {
  const EmptyAudioBackground({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 2 / 3,
      child: Image.asset(
        'assets/images/junto-mobile__themes--rainbow.png',
        fit: BoxFit.cover,
      ),
    );
  }
}

class AudioPlaybackRow extends StatelessWidget {
  const AudioPlaybackRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audio, child) {
        return Row(
          children: <Widget>[
            AudioPlayButton(),
            AudioSeek(),
            AudioPosition(),
          ],
        );
      },
    );
  }
}
