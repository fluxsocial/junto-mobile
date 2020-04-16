import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_expression_scaffold.dart';
import 'package:provider/provider.dart';
import 'audio_service.dart';
import 'widgets/audio_bottom_tools.dart';
import 'widgets/audio_button.dart';
import 'widgets/audio_timer.dart';
import 'widgets/audio_seek.dart';

class CreateAudioNew extends StatefulWidget {
  const CreateAudioNew({Key key, this.expressionContext, this.address})
      : super(key: key);
  final ExpressionContext expressionContext;
  final String address;

  @override
  State<StatefulWidget> createState() {
    return CreateAudioNewState();
  }
}

class CreateAudioNewState extends State<CreateAudioNew> {
  bool _showBottomNav = true;
  setBottomNav(bool visibility) {
    setState(() {
      _showBottomNav = visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AudioService>(
      create: (context) => AudioService(),
      child: Consumer<AudioService>(builder: (context, audio, child) {
        return CreateExpressionScaffold(
          showBottomNav: _showBottomNav,
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
                                Container(
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
                                        ),
                                      ]),
                                  child: Stack(
                                    children: <Widget>[
                                      ClipOval(
                                        child: Container(
                                          height: 80,
                                          width: 80,
                                          child: Image.asset(
                                            'assets/images/junto-mobile__themes--rainbow.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 80,
                                        width: 80,
                                        alignment: Alignment.center,
                                        child: AudioButton(
                                            setBottomNav: setBottomNav),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                !audio.playBackAvailable
                                    ? AudioTimer(audio: audio)
                                    : AudioSeek()
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                if (!_showBottomNav)
                  AudioBottomTools(setBottomNav: setBottomNav),
              ],
            ),
          ),
        );
      }),
    );
  }
}
