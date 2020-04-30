import 'dart:io';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:junto_beta_mobile/widgets/audio/audio_preview.dart';
import 'package:provider/provider.dart';

class AudioReview extends StatelessWidget {
  const AudioReview({
    this.audioPhotoBackground,
    this.titleController,
  });
  final File audioPhotoBackground;
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
              child: Container(
                height: 100,
                // height: MediaQuery.of(context).size.width * 2 / 3,
                decoration: BoxDecoration(
                  // image: DecorationImage(
                  //   image: audioPhotoBackground != null
                  //       ? FileImage(audioPhotoBackground)
                  //       : null,
                  //   fit: BoxFit.fitWidth,
                  // ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: const <double>[0.2, 0.9],
                    colors: <Color>[
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: Container(
                  color: Colors.black54,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AudioTitle(
                        titleController: titleController,
                        hasBackground:
                            audioPhotoBackground != null ? true : false,
                      ),
                      AudioPlaybackRow(
                        hasBackground:
                            audioPhotoBackground != null ? true : false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
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
