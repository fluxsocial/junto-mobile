import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create_resonation/create_resonation_appbar.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/widgets/expression_preview/expression_preview.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

class CreateResonation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateResonationState();
  }
}

class CreateResonationState extends State<CreateResonation> {
  List expressions = [
    CentralizedExpressionResponse(
      address: '0xfee32zokie8',
      type: 'LongForm',
      comments: <Comment>[],
      context: '',
      createdAt: DateTime.now(),
      creator: UserProfile(
        bio: 'hellooo',
        firstName: 'Eric',
        lastName: 'Yang',
        username: 'sunyata',
        profilePicture: 'assets/images/junto-mobile__eric.png',
        verified: true,
      ),
      expressionData: CentralizedLongFormExpression(
        title: 'Dynamic form is in motion!',
        body: "Hey! Eric here. We're currently working with a London-based dev "
            "agency called DevAngels to build out our dynamic, rich text editor. Soon, you'll be able to create short or longform expressions that contain text, links, images complemented with features such as bullet points, horiozntal lines, bold and italic font, and much more. This should be done in the next 1 or 2 weeks so stay tuned!",
      ),
    ),
  ];
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
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffeeeeee), width: 1),
                        borderRadius: BorderRadius.circular(5),),
                    child: ExpressionPreview(expression: expressions[0]),
                  )
                ],
              )),
            ],
          ),
        ));
  }
}
