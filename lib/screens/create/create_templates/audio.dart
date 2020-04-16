import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_expression_scaffold.dart';
import 'package:provider/provider.dart';
import 'audio_service.dart';
import 'widgets/audio_bottom_tools.dart';
import 'widgets/audio_button.dart';
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
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AudioService>(
      create: (context) => AudioService(),
      child: Consumer<AudioService>(builder: (context, audio, child) {
        return CreateExpressionScaffold(
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
}

class AudioButtonDecoration extends StatelessWidget {
  const AudioButtonDecoration({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Colors.white,
          width: 5,
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).dividerColor,
            blurRadius: 9,
          )
        ],
      ),
      child: child,
    );
  }
}
