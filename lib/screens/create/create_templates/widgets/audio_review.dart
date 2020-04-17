import 'dart:io';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:provider/provider.dart';
import 'audio_play.dart';
import 'audio_position.dart';
import 'audio_seek.dart';

class AudioReview extends StatelessWidget {
  const AudioReview({this.audioPhotoBackground});
  final File audioPhotoBackground;
  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(builder: (context, audio, child) {
      return ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 2 / 3,
            child: Stack(
              children: <Widget>[
                if (audioPhotoBackground == null)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 2 / 3,
                    child: Image.asset(
                      'assets/images/junto-mobile__themes--rainbow.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                if (audioPhotoBackground != null)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 2 / 3,
                    child: Image.file(
                      audioPhotoBackground,
                      fit: BoxFit.cover,
                    ),
                  ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 2 / 3,
                  color: Colors.black38,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          autofocus: false,
                          buildCounter: (
                            BuildContext context, {
                            int currentLength,
                            int maxLength,
                            bool isFocused,
                          }) =>
                              null,
                          decoration: InputDecoration(
                            hintMaxLines: 25,
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            border: InputBorder.none,
                            hintText: 'Title (optional)',
                          ),
                          cursorColor: Colors.white,
                          cursorWidth: 2,
                          maxLines: null,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLength: 80,
                          textInputAction: TextInputAction.done,
                          keyboardAppearance: Theme.of(context).brightness,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          AudioPlayButton(),
                          AudioSeek(),
                          Text(
                            AudioPosition().getCurrentPosition(audio) +
                                ' / ' +
                                AudioPosition().getMaxDuration(audio),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
