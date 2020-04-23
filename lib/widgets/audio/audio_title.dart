import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';

class AudioPreviewTitle extends StatelessWidget {
  const AudioPreviewTitle({
    Key key,
    @required this.audio,
  }) : super(key: key);

  final AudioFormExpression audio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 8.0,
        right: 8.0,
      ),
      child: Text(
        audio.title,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
