import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/create_resonation/create_resonation_appbar.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview_embed/expression_preview_embed.dart';

class CreateResonation extends StatefulWidget {
  const CreateResonation({Key key, @required this.expression})
      : super(key: key);

  final CentralizedExpressionResponse expression;

  @override
  State<StatefulWidget> createState() {
    return CreateResonationState();
  }
}

class CreateResonationState extends State<CreateResonation> {
  FocusNode resonationCommentFocusNode;

  @override
  void initState() {
    super.initState();
    resonationCommentFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    resonationCommentFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: CreateResonationAppbar(),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      focusNode: resonationCommentFocusNode,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'add a comment',
                          hintStyle: Theme.of(context).textTheme.caption),
                      maxLines: null,
                      cursorColor: Theme.of(context).primaryColorDark,
                      cursorWidth: 2,
                      style: Theme.of(context).textTheme.caption,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child:
                        ExpressionPreviewEmbed(expression: widget.expression),
                  ),
                ],
              ),
            ),
            resonationCommentFocusNode.hasFocus
                ? Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                            color: Theme.of(context).dividerColor, width: 1),
                      ),
                    ),
                    child: Row(
                      children: const <Widget>[
                        Text('Stickers'),
                        SizedBox(width: 10),
                        Text('GIF')
                      ],
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
