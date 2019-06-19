import 'package:flutter/material.dart';

import '../../custom_icons.dart';
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
      } else {
        return ShortformOpen(widget.expression);
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
          children: <Widget>[
            Expanded(
              child: ListView(children: [
                ExpressionOpenTop(),
                _buildExpression(),
                ExpressionOpenBottom(
                    channelOne: widget.expression.channels[0],
                    channelTwo: widget.expression.channels[1],
                    channelThree: widget.expression.channels[2],
                    time: '2'),
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
          ],
        ),
      ),
      bottomNavigationBar: ExpressionOpenBottomNav()

    );
  }
}
