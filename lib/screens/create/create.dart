import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/event.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/longform.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/photo.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/shortform.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';

import 'create_actions/widgets/create_expression_icon.dart';
import 'create_actions/widgets/home_icon.dart';

class JuntoCreate extends StatelessWidget {
  const JuntoCreate({
    @required this.channels,
    @required this.address,
    @required this.expressionContext,
    @required this.expressionCenterBackground,
  });

  final List<String> channels;
  final String address;
  final ExpressionContext expressionContext;
  final String expressionCenterBackground;

  void _navigateTo(BuildContext context, ExpressionType expression) {
    switch (expression) {
      case ExpressionType.dynamic:
        _push(
            context,
            CreateLongform(
                expressionContext: expressionContext, address: address),
            expression);
        break;
      case ExpressionType.event:
        _push(
            context,
            CreateEvent(expressionContext: expressionContext, address: address),
            expression);
        break;
      case ExpressionType.shortform:
        _push(
            context,
            CreateShortform(
                expressionContext: expressionContext, address: address),
            expression);
        break;
      case ExpressionType.photo:
        _push(
            context,
            CreatePhoto(expressionContext: expressionContext, address: address),
            expression);
        break;
      default:
    }
  }

  void _push(BuildContext context, Widget form, ExpressionType expression) {
    Navigator.push(
      context,
      FadeRoute<void>(
        child: form,
      ),
    );
  }

  Widget _expressionCenter(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            expressionCenterBackground,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _selectExpressionIcon(ExpressionType.dynamic),
                      _selectExpressionIcon(ExpressionType.shortform),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _selectExpressionIcon(ExpressionType.photo),
                      _selectExpressionIcon(ExpressionType.event),
                    ],
                  ),
                ),
                const HomeIcon(),
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
