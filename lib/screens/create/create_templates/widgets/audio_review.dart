import 'dart:io';
import 'package:flutter/material.dart';
import 'audio_play.dart';
import 'audio_seek.dart';

class AudioReview extends StatelessWidget {
  const AudioReview({this.audioPhotoBackground});
  final File audioPhotoBackground;
  @override
  Widget build(BuildContext context) {
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
                  color: Colors.blue,
                  child: Image.asset(
                    'assets/images/junto-mobile__themes--rainbow.png',
                    fit: BoxFit.cover,
                  ),
                ),
              if (audioPhotoBackground != null)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 2 / 3,
                  color: Colors.blue,
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
                            color: Colors.white.withOpacity(0.5),
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
  }
}
