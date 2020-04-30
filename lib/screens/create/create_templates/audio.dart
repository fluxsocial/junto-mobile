import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_expression_scaffold.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';
import 'package:provider/provider.dart';
import 'audio_service.dart';
import 'widgets/audio_bottom_tools.dart';
import 'widgets/audio_gradient_selector.dart';
import 'widgets/audio_record.dart';
import 'widgets/audio_review.dart';

class CreateAudio extends StatefulWidget {
  const CreateAudio({Key key, this.expressionContext, this.address})
      : super(key: key);
  final ExpressionContext expressionContext;
  final String address;

  @override
  State<StatefulWidget> createState() {
    return CreateAudioState();
  }
}

class CreateAudioState extends State<CreateAudio> {
  final TextEditingController titleController = TextEditingController();
  File audioPhotoBackground;

  Future<void> _onPickPressed() async {
    try {
      final File image =
          await ImagePicker.pickImage(source: ImageSource.gallery);
      if (image == null && audioPhotoBackground == null) {
        setState(() => audioPhotoBackground = null);
        return;
      } else if (image == null && audioPhotoBackground != null) {
        return;
      }

      final File cropped = await ImageCroppingDialog.show(
        context,
        image,
        aspectRatios: <String>[
          '3:2',
        ],
      );
      Navigator.of(context).focusScopeNode.unfocus();
      if (cropped == null) {
        setState(() => audioPhotoBackground = null);

        return;
      }
      setState(() => audioPhotoBackground = cropped);
    } catch (error) {
      print(error);
    }
  }

  void _resetAudioPhotoBackground() {
    setState(() {
      audioPhotoBackground = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AudioService>(
      create: (context) => AudioService(),
      child: Consumer<AudioService>(builder: (context, audio, child) {
        return CreateExpressionScaffold(
          onNext: () => _onNext(audio),
          showBottomNav: !audio.playBackAvailable,
          expressionType: ExpressionType.audio,
          child: Expanded(
            child: Stack(
              children: <Widget>[
                !audio.playBackAvailable
                    ? AudioRecord()
                    : AudioReview(
                        audioPhotoBackground: audioPhotoBackground,
                        titleController: titleController,
                      ),
                if (audio.playBackAvailable)
                  AudioBottomTools(
                    onPickPressed: _onPickPressed,
                    resetAudioPhotoBackground: _resetAudioPhotoBackground,
                  ),
                  // AudioGradientSelector()
              ],
            ),
          ),
        );
      }),
    );
  }

  void _onNext(AudioService audio) {
    if (_validate(audio)) {
      final audioExpression = AudioFormExpression(
        title: titleController.text,
        photo: audioPhotoBackground?.path,
        audio: audio.recordingPath,
      );
      Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) {
            return CreateActions(
              expressionType: ExpressionType.audio,
              address: widget.address,
              expressionContext: widget.expressionContext,
              expression: audioExpression,
            );
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: "Seems like you haven't recorded anything",
        ),
      );
      return;
    }
  }

  bool _validate(AudioService audio) {
    if (audio.playBackAvailable && audio.recordingPath != null
        //TODO: add validation for title and image if necessary
        ) {
      return true;
    }
    return false;
  }
}
