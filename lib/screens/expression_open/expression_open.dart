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
  bool _showCommentTextField = false;
  bool _showReplies = false;
  Widget _showRepliesText = Row(
    children: <Widget>[
      Text('SHOW REPLIES',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      SizedBox(width: 5),
      Icon(Icons.keyboard_arrow_down, size: 17, color: Color(0xff555555))
    ],
  );

  @override
  Widget build(BuildContext context) {
    _buildExpression() {
      if (widget.expression.expression['expression_type'] == 'longform') {
        return LongformOpen(widget.expression);
      } else if (widget.expression.expression['expression_type'] ==
          'shortform') {
        return ShortformOpen(widget.expression);
      }
    }

    void _openComment() {
      if (_showCommentTextField == false) {
        setState(() {
          _showCommentTextField = true;
        });
      }
    }

    void _toggleReplies() {
      if (_showReplies == false) {
        setState(() {
          _showReplies = true;
          _showRepliesText = Row(
            children: <Widget>[
              Text('REPLIES',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              SizedBox(width: 5),
              Icon(Icons.keyboard_arrow_up, size: 17, color: Color(0xff555555))
            ],
          );
        });
      } else {
        setState(() {
          _showReplies = false;
          _showRepliesText = Row(
            children: <Widget>[
              Text('SHOW REPLIES',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              SizedBox(width: 5),
              Icon(Icons.keyboard_arrow_down,
                  size: 17, color: Color(0xff555555))
            ],
          );
        });
      }
    }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(45.0), child: ExpressionOpenAppbar()),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(children: [
                ExpressionOpenTop(),
                _buildExpression(),
                ExpressionOpenBottom(
                    channels: widget.expression.channels, time: '2'),
                ExpressionOpenShowReplies(_toggleReplies, _showRepliesText),
                _showReplies == true
                    ? ListView(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: [
                            CommentPreview(),
                            CommentPreview(),
                            CommentPreview(),
                            CommentPreview(),
                            CommentPreview(),
                            CommentPreview(),
                            CommentPreview(),
                            CommentPreview()
                          ])
                    : SizedBox(),
              ]),
            ),
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
                      child: Row(children: <Widget>[
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
                            width: MediaQuery.of(context).size.width - 135,
                            constraints: BoxConstraints(
                              maxHeight: 180
                            ),
                            color: Colors.white,
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                // hintText: 'reply',
                              ),
                              maxLines: null,
                              cursorColor: JuntoPalette.juntoGrey,
                              cursorWidth: 2,
                              style: TextStyle(fontSize: 17, color: Color(0xff333333)),
                              textInputAction: TextInputAction.newline,
                            ),
                        ),                        
                      ],)
                    ),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [0.1, 0.9],
                          colors: [JuntoPalette.juntoBlue, JuntoPalette.juntoPurple]
                        )
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text('REPLY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12))
                    )
                  ],  
                ))
          ],
        ),
      ),
      // bottomNavigationBar: ExpressionOpenBottomNav(_openComment)
    );
  }
}
