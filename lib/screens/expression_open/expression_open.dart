import 'package:flutter/material.dart';

import '../../custom_icons.dart';
import '../../typography/style.dart';
import '../../typography/palette.dart';
import './expression_open_bottom_nav/expression_open_bottom_nav.dart';
import '../../components/comment_preview/comment_preview.dart';
import './expression_open_appbar/expression_open_appbar.dart';
import './expression_open_top/expression_open_top.dart';
import './expression_open_bottom/expression_open_bottom.dart';
import './expression_open_showreplies/expression_open_showreplies.dart';
import './expressions/longform_open/longform_open.dart';
import './expressions/shortform_open/shortform_open.dart';

class ExpressionOpen extends StatefulWidget {
  final expression;
  ExpressionOpen(this.expression);

  @override
  State<StatefulWidget> createState() {
    return ExpressionOpenState();
  }
}

class ExpressionOpenState extends State<ExpressionOpen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController commentController = TextEditingController();

    _buildExpression() {
      String expressionType =
          widget.expression.expression['entry']['expression_type'];

      if (expressionType == 'longform') {
        return LongformOpen(widget.expression);
      } else if (expressionType == 'shortform') {
        return ShortformOpen(widget.expression);
      } else {
        return SizedBox();
      }
    }

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(45.0),
            child: ExpressionOpenAppbar()),
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Expanded(
                child: ListView(
              children: <Widget>[
                ExpressionOpenTop(widget.expression),
                _buildExpression(),
                ExpressionOpenBottom(widget.expression),
              ],
            )),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(width: 1, color: Color(0xffeeeeee)))),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/junto-mobile__eric.png',
                              height: 36.0,
                              width: 36.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Color(0xfff9f9f9),
                              borderRadius: BorderRadius.circular(10)),
                          width: MediaQuery.of(context).size.width - 135,
                          constraints: BoxConstraints(maxHeight: 180),
                          child: TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              // hintText: 'reply',
                            ),
                            maxLines: null,
                            cursorColor: JuntoPalette.juntoGrey,
                            cursorWidth: 2,
                            style: TextStyle(
                                fontSize: 17, color: Color(0xff333333)),
                            textInputAction: TextInputAction.newline,
                          ),
                        ),
                      ],
                    )),
                    GestureDetector(
                        onTap: () {},
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    stops: [
                                      0.1,
                                      0.9
                                    ],
                                    colors: [
                                      JuntoPalette.juntoBlue,
                                      JuntoPalette.juntoPurple
                                    ])),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text('REPLY',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12))))
                  ],
                ))
          ],
        ));
  }
}
