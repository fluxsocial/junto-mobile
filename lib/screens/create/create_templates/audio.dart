import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_expression_scaffold.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:provider/provider.dart';
import 'audio_service.dart';
import 'widgets/audio_bottom_tools.dart';
import 'widgets/audio_button.dart';
import 'widgets/audio_button_decoration.dart';
import 'widgets/audio_seek.dart';
import 'widgets/audio_timer.dart';

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
  String imagePath;

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
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Transform.translate(
                        offset: Offset(0.0, -50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                AudioButtonDecoration(
                                  child: AudioButtonStack(),
                                ),
                                const SizedBox(height: 15),
                                audio.playBackAvailable
                                    ? AudioSeek()
                                    : AudioTimer(audio: audio)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                if (audio.playBackAvailable) AudioBottomTools(),
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
        imageUrl: imagePath,
        audioUrl: audio.recordingPath,
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
