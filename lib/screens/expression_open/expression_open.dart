import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_appbar/expression_open_appbar.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_bottom/expression_open_bottom.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_top/expression_open_top.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/longform_open/longform_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/shortform_open/shortform_open.dart';
import 'package:junto_beta_mobile/typography/palette.dart';

class ExpressionOpen extends StatefulWidget {
  const ExpressionOpen(this.expression);

  final dynamic expression;

  @override
  State<StatefulWidget> createState() {
    return ExpressionOpenState();
  }
}

class ExpressionOpenState extends State<ExpressionOpen> {
  TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  /// Builds an expression for the given type. IE: Longform or shortform
  Widget _buildExpression() {
    final String expressionType =
        widget.expression.expression['entry']['expression_type'];
    if (expressionType == 'longform') {
      return LongformOpen(widget.expression);
    } else if (expressionType == 'shortform') {
      return ShortformOpen(widget.expression);
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45.0),
        child: ExpressionOpenAppbar(),
      ),
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
                top: BorderSide(
                  width: 1,
                  color: const Color(0xffeeeeee),
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(right: 10),
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
                          color: const Color(0xfff9f9f9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery.of(context).size.width - 135,
                        constraints: const BoxConstraints(maxHeight: 180),
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            // hintText: 'reply',
                          ),
                          maxLines: null,
                          cursorColor: JuntoPalette.juntoGrey,
                          cursorWidth: 2,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Color(0xff333333),
                          ),
                          textInputAction: TextInputAction.newline,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: <double>[0.1, 0.9],
                        colors: <Color>[
                          JuntoPalette.juntoBlue,
                          JuntoPalette.juntoPurple
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Text(
                      'REPLY',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
