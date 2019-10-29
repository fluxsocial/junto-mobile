import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview_types/event_preview.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview_types/longform_preview.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview_types/photo_preview.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview_types/shortform_preview.dart';

class ExpressionPreviewEmbed extends StatelessWidget {
  const ExpressionPreviewEmbed({Key key, @required this.expression})
      : super(key: key);

  final CentralizedExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xffeeeeee), width: 1),
          borderRadius: BorderRadius.circular(5),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Color(0xffeeeeee), blurRadius: 7)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // expression preview profile
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // profile picture
                      ClipOval(
                        child: Image.asset(
                          expression.creator.profilePicture,
                          height: 38.0,
                          width: 38.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 7.5),
                        child: Text(
                          expression.creator.username,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 24,
                        color: Color(0xff777777),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          _returnExpression(expression),

          Container(
            margin: const EdgeInsets.only(top: 7.5),
            padding: const EdgeInsets.symmetric(
                horizontal: JuntoStyles.horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          'today',
                          textAlign: TextAlign.start,
                          style: JuntoStyles.expressionTimestamp,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _returnExpression(CentralizedExpressionResponse expression) {
    if (expression.type == 'LongForm') {
      return LongformPreview(expression: expression);
    } else if (expression.type == 'ShortForm') {
      return ShortformPreview(expression);
    } else if (expression.type == 'PhotoForm') {
      return PhotoPreview(expression: expression);
    } else if (expression.type == 'EventForm') {
      return EventPreview(expression: expression);
    } else {
      return Container();
    }
  }
}
