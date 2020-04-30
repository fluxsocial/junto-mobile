import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:junto_beta_mobile/widgets/audio/audio_preview.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';

class AudioOpen extends StatelessWidget {
  AudioOpen(this.expression);
  final ExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    final audioRecording = expression.expressionData.audio;
    final audioTitle = expression.expressionData.title;
    final audioGradients = expression.expressionData.gradient;
    final audioPhoto = expression.expressionData.photo;

    Widget _displayAudioOpen() {
      if (audioGradients.isEmpty && audioPhoto.isEmpty) {
        return AudioOpenDefault(
          title: audioTitle,
        );
      } else if (audioPhoto.isNotEmpty) {
        return AudioOpenWithPhoto(
          title: audioTitle,
          photo: audioPhoto,
        );
      } else if (audioGradients.isNotEmpty && audioGradients.length == 2) {
        return AudioOpenWithGradients(
          gradients: audioGradients,
          title: audioTitle,
        );
      } else {
        return AudioOpenDefault(title: audioTitle);
      }
    }

    return ChangeNotifierProvider<AudioService>(
      create: (context) => AudioService()..initializeFromWeb(audioRecording),
      lazy: false,
      child: Consumer<AudioService>(builder: (context, audio, child) {
        return _displayAudioOpen();
      }),
    );
  }
}

class AudioOpenTitle extends StatelessWidget {
  AudioOpenTitle({this.title, this.color});
  final String title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class AudioOpenDefault extends StatelessWidget {
  AudioOpenDefault({this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * .17,
      ),
      padding: const EdgeInsets.symmetric(vertical: 25),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: .5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          title.isNotEmpty
              ? AudioOpenTitle(
                  title: title,
                  color: Theme.of(context).primaryColor,
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: AudioPlaybackRow(hasBackground: false),
          ),
        ],
      ),
    );
  }
}

class AudioOpenWithGradients extends StatelessWidget {
  AudioOpenWithGradients({this.title, this.gradients});
  final String title;
  final List<String> gradients;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * .17,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: const <double>[
              0.1,
              0.9
            ],
            colors: <Color>[
              HexColor.fromHex(gradients[0]),
              HexColor.fromHex(gradients[1]),
            ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          title.isNotEmpty
              ? AudioOpenTitle(
                  title: title,
                  color: Colors.white,
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: AudioPlaybackRow(
              hasBackground: true,
            ),
          ),
        ],
      ),
    );
  }
}

class AudioOpenWithPhoto extends StatelessWidget {
  AudioOpenWithPhoto({this.title, this.photo});
  final String title;
  final String photo;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          foregroundDecoration: BoxDecoration(color: Colors.black38),
          width: MediaQuery.of(context).size.width,
          child: CachedNetworkImage(imageUrl: photo),
        ),
        if (title.isNotEmpty)
          Positioned(
            top: 25,
            left: 0,
            right: 0,
            child: AudioOpenTitle(
              title: title,
              color: Colors.white,
            ),
          ),
        Positioned(
          bottom: 25,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: AudioPlaybackRow(
              hasBackground: true,
            ),
          ),
        )
      ],
    );
  }
}
