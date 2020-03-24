import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/event.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/longform.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/photo.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/shortform.dart';
import 'package:junto_beta_mobile/widgets/background/background_theme.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'create_actions/widgets/create_expression_icon.dart';
import 'create_actions/widgets/home_icon.dart';

class JuntoCreate extends StatefulWidget {
  const JuntoCreate({
    @required this.channels,
    @required this.address,
    @required this.expressionContext,
  });

  final List<String> channels;
  final String address;
  final ExpressionContext expressionContext;

  @override
  State<StatefulWidget> createState() {
    return JuntoCreateState();
  }
}

class JuntoCreateState extends State<JuntoCreate> {
  dynamic source;

  void _navigateTo(BuildContext context, ExpressionType expression) {
    switch (expression) {
      case ExpressionType.dynamic:
        _push(
            context,
            CreateLongform(
                expressionContext: widget.expressionContext,
                address: widget.address),
            expression);
        break;
      case ExpressionType.event:
        _push(
            context,
            CreateEvent(
                expressionContext: widget.expressionContext,
                address: widget.address),
            expression);
        break;
      case ExpressionType.shortform:
        _push(
            context,
            CreateShortform(
                expressionContext: widget.expressionContext,
                address: widget.address),
            expression);
        break;
      case ExpressionType.photo:
        _push(
            context,
            CreatePhoto(
              expressionContext: widget.expressionContext,
              address: widget.address,
            ),
            expression);
        break;
      default:
    }
  }

  void _push(
      BuildContext context, Widget form, ExpressionType expression) async {
    final ExpressionType expressionType = await Navigator.push(
      context,
      FadeRoute<ExpressionType>(
        child: form,
      ),
    );
    setState(() {
      source = expressionType;
    });
    logger.logDebug(source);
  }

  Widget _expressionCenter(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: BackgroundTheme(),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Row(
                    children: <Widget>[
                      _selectExpressionIcon(ExpressionType.dynamic),
                      _selectExpressionIcon(ExpressionType.shortform),
                      _selectExpressionIcon(ExpressionType.photo),
                    ],
                  ),
                ),
                HomeIcon(
                  source: source,
                  navigateTo: _navigateTo,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _expressionCenter(context),
    );
  }

  Widget _selectExpressionIcon(ExpressionType expressionType) {
    return CreateExpressionIcon(
      expressionType: expressionType,
      onTap: _navigateTo,
    );
  }
}
