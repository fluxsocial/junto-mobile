import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';

class AudioPreview extends StatelessWidget {
  AudioPreview({@required this.expression});
  final ExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    final audioTitle = expression.expressionData.title;
    final audioGradients = expression.expressionData.gradient;
    final audioPhoto = expression.expressionData.photo;

    Widget _displayAudioPreview() {
      if (audioGradients.isEmpty && audioPhoto.isEmpty) {
        return AudioPreviewDefault(
          title: audioTitle,
        );
      } else if (audioPhoto.isNotEmpty) {
        return AudioPreviewWithPhoto(
          title: audioTitle,
          photo: audioPhoto,
        );
      } else if (audioGradients.isNotEmpty && audioGradients.length == 2) {
        return AudioPreviewWithGradients(
          gradients: audioGradients,
          title: audioTitle,
        );
      } else {
        return AudioPreviewDefault(title: audioTitle);
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        child: _displayAudioPreview(),
      ),
    );
  }
}

class AudioPreviewWaveform extends StatelessWidget {
  AudioPreviewWaveform({this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/junto-mobile__waveform.png',
      height: 38,
      color: color,
    );
  }
}

class AudioPreviewTitle extends StatelessWidget {
  AudioPreviewTitle({this.title, this.color});
  final String title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: color,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class AudioPreviewDefault extends StatelessWidget {
  AudioPreviewDefault({this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 50.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: .5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (title.isNotEmpty)
            AudioPreviewTitle(
              title: title,
              color: Theme.of(context).primaryColor,
            ),
          AudioPreviewWaveform(
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}

class AudioPreviewWithGradients extends StatelessWidget {
  AudioPreviewWithGradients({this.title, this.gradients});
  final String title;
  final List<String> gradients;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 50.0,
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
        children: <Widget>[
          if (title.isNotEmpty)
            AudioPreviewTitle(
              title: title,
              color: Colors.white,
            ),
          AudioPreviewWaveform(
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class AudioPreviewWithPhoto extends StatelessWidget {
  AudioPreviewWithPhoto({this.title, this.photo});
  final String title;
  final String photo;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 50.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black38,
            BlendMode.srcOver,
          ),
          image: NetworkImage(
            photo,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (title.isNotEmpty)
            AudioPreviewTitle(
              title: title,
              color: Colors.white,
            ),
          AudioPreviewWaveform(
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
