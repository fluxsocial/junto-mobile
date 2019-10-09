import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create_resonation/create_resonation_appbar.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/widgets/expression_preview/expression_preview_embed/expression_preview_embed.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

class CreateResonation extends StatefulWidget {
  CreateResonation({Key key, @required this.expression}) : super(key: key);

  final expression;

  @override
  State<StatefulWidget> createState() {
    return CreateResonationState();
  }
}

class CreateResonationState extends State<CreateResonation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: CreateResonationAppbar(),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Add a comment',
                    ),
                    maxLines: null,
                    cursorColor: JuntoPalette.juntoGrey,
                    cursorWidth: 2,
                    style: const TextStyle(
                      fontSize: 17,
                      color: JuntoPalette.juntoGrey,
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                ExpressionPreviewEmbed(expression: widget.expression),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
