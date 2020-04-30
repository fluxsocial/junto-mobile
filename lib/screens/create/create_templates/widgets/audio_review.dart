import 'dart:io';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:junto_beta_mobile/widgets/audio/audio_preview.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';
import 'package:provider/provider.dart';

class AudioReview extends StatelessWidget {
  const AudioReview({
    this.audioPhotoBackground,
    this.audioGradientValues,
    this.titleController,
  });
  final File audioPhotoBackground;
  final List<String> audioGradientValues;
  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(builder: (context, audio, child) {
      return ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: _showAudioReviewTemplate(),
            ),
          ),
        ],
      );
    });
  }

  Widget _showAudioReviewTemplate() {
    if (audioPhotoBackground == null && audioGradientValues.isEmpty) {
      return AudioReviewDefault();
    } else if (audioPhotoBackground != null && audioGradientValues.isEmpty) {
      return AudioReviewWithPhoto(
        audioPhotoBackground: audioPhotoBackground,
      );
    } else if (audioPhotoBackground == null && audioGradientValues.isNotEmpty) {
      return AudioReviewWithGradient(
        audioGradientValues: audioGradientValues,
      );
    } else {
      return AudioReviewDefault();
    }
  }
}

class AudioReviewDefault extends StatelessWidget {
  AudioReviewDefault({this.titleController});

  final titleController;
  @override
  Widget build(BuildContext context) {
    return AudioReviewBody(
      hasBackground: false,
      titleController: titleController,
    );
  }
}

class AudioReviewWithGradient extends StatelessWidget {
  AudioReviewWithGradient({
    this.titleController,
    this.audioGradientValues,
  });

  final titleController;
  final List<String> audioGradientValues;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 2 / 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: <double>[0.2, 0.9],
          colors: <Color>[
            HexColor.fromHex(audioGradientValues[0]),
            HexColor.fromHex(audioGradientValues[1]),
          ],
        ),
      ),
      child: AudioReviewBody(
        hasBackground: true,
        titleController: titleController,
      ),
    );
  }
}

class AudioReviewWithPhoto extends StatelessWidget {
  AudioReviewWithPhoto({
    this.titleController,
    this.audioPhotoBackground,
  });

  final titleController;
  final File audioPhotoBackground;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 2 / 3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(audioPhotoBackground),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: AudioReviewBody(
        hasBackground: true,
        titleController: titleController,
      ),
    );
  }
}

class AudioReviewBody extends StatelessWidget {
  AudioReviewBody({
    this.titleController,
    this.hasBackground,
  });
  final titleController;
  final bool hasBackground;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: hasBackground ? Colors.black54 : Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AudioTitle(
            titleController: titleController,
            hasBackground: hasBackground,
          ),
          AudioPlaybackRow(
            hasBackground: hasBackground,
          ),
        ],
      ),
    );
  }
}

class AudioTitle extends StatelessWidget {
  const AudioTitle({
    Key key,
    @required this.titleController,
    @required this.hasBackground,
  }) : super(key: key);

  final TextEditingController titleController;
  final bool hasBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: TextField(
        controller: titleController,
        autofocus: false,
        decoration: InputDecoration(
          hintMaxLines: 25,
          hintStyle: TextStyle(
            color:
                hasBackground ? Colors.white : Theme.of(context).primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          border: InputBorder.none,
          hintText: S.of(context).audio_title,
          counter: SizedBox(),
        ),
        cursorColor:
            hasBackground ? Colors.white : Theme.of(context).primaryColor,
        cursorWidth: 2,
        maxLines: null,
        style: TextStyle(
          color: hasBackground ? Colors.white : Theme.of(context).primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        maxLength: 80,
        textInputAction: TextInputAction.done,
        keyboardAppearance: Theme.of(context).brightness,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}
