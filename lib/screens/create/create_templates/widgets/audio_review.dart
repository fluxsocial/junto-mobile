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
    this.captionController,
    this.captionFocus,
  });
  final File audioPhotoBackground;
  final List<String> audioGradientValues;
  final TextEditingController titleController;
  final TextEditingController captionController;
  final FocusNode captionFocus;

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
      return AudioReviewDefault(
        titleController: titleController,
        captionController: captionController,
        captionFocus: captionFocus,
      );
    } else if (audioPhotoBackground != null && audioGradientValues.isEmpty) {
      return AudioReviewWithPhoto(
        titleController: titleController,
        captionController: captionController,
        audioPhotoBackground: audioPhotoBackground,
        captionFocus: captionFocus,
      );
    } else if (audioPhotoBackground == null && audioGradientValues.isNotEmpty) {
      return AudioReviewWithGradient(
        titleController: titleController,
        captionController: captionController,
        audioGradientValues: audioGradientValues,
        captionFocus: captionFocus,
      );
    } else {
      return AudioReviewDefault(
        captionController: captionController,
        titleController: titleController,
        captionFocus: captionFocus,
      );
    }
  }
}

class AudioReviewDefault extends StatelessWidget {
  AudioReviewDefault({
    this.titleController,
    this.captionController,
    this.captionFocus,
  });

  final TextEditingController titleController;
  final TextEditingController captionController;
  final FocusNode captionFocus;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AudioReviewBody(
          hasBackground: false,
          titleController: titleController,
        ),
        AudioCaption(
          captionController: captionController,
          captionFocus: captionFocus,
        ),
      ],
    );
  }
}

class AudioReviewWithGradient extends StatelessWidget {
  AudioReviewWithGradient({
    this.titleController,
    this.captionController,
    this.captionFocus,
    this.audioGradientValues,
  });

  final TextEditingController titleController;
  final TextEditingController captionController;
  final FocusNode captionFocus;
  final List<String> audioGradientValues;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
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
        ),
        AudioCaption(
          captionController: captionController,
          captionFocus: captionFocus,
        ),
      ],
    );
  }
}

class AudioReviewWithPhoto extends StatelessWidget {
  AudioReviewWithPhoto({
    this.titleController,
    this.captionController,
    this.captionFocus,
    this.audioPhotoBackground,
  });

  final titleController;
  final TextEditingController captionController;
  final FocusNode captionFocus;
  final File audioPhotoBackground;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(children: [
          Container(
            foregroundDecoration: BoxDecoration(
              color: Colors.black54,
            ),
            child: Image.file(
              audioPhotoBackground,
            ),
          ),
          Positioned(
            top: 15,
            left: 0,
            right: 0,
            child: AudioTitle(
              titleController: titleController,
              hasBackground: true,
            ),
          ),
          Positioned(
            bottom: 15,
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
          ),
        ]),
        AudioCaption(
          captionController: captionController,
          captionFocus: captionFocus,
        ),
      ],
    );
  }
}

class AudioReviewBody extends StatelessWidget {
  AudioReviewBody({
    this.titleController,
    this.hasBackground,
  });
  final TextEditingController titleController;
  final bool hasBackground;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: hasBackground ? Colors.black45 : Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AudioTitle(
            titleController: titleController,
            hasBackground: hasBackground,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: AudioPlaybackRow(
              hasBackground: hasBackground,
            ),
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
      ),
      margin: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: titleController,
        autofocus: false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
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

class AudioCaption extends StatelessWidget {
  const AudioCaption({
    Key key,
    @required this.captionController,
    @required this.captionFocus,
  }) : super(key: key);

  final TextEditingController captionController;
  final FocusNode captionFocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextField(
        controller: captionController,
        focusNode: captionFocus,
        autofocus: false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          hintStyle: TextStyle(
            color: Theme.of(context).primaryColorLight,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          hintText: 'Write a caption...',
          counter: SizedBox(),
        ),
        cursorColor: Theme.of(context).primaryColor,
        cursorWidth: 2,
        maxLines: null,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
        textInputAction: TextInputAction.newline,
        keyboardAppearance: Theme.of(context).brightness,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}
