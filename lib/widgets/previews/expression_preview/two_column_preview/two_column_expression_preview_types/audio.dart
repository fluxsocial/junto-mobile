import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/common/audio.dart';

class AudioPreview extends StatelessWidget {
  AudioPreview({@required this.expression});
  final ExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CommonAudioPreview(
        expression: expression,
      ),
    );
  }
}
