import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_expression_scaffold.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';

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
  @override
  Widget build(BuildContext context) {
    return CreateExpressionScaffold(
      showBottomNav: _showBottomNav,
      expressionType: ExpressionType.audio,
      child: Expanded(
        child: Column(
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
                                child: Icon(
                                  Icons.mic,
                                  size: 33,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          child: Text(
                            '0:00',
                            style: TextStyle(
                              fontSize: 28,
                              letterSpacing: 1.7,
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(),
            ]),
      ),
    );
  }
}
