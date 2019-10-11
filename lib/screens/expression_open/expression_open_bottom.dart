import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/screens/create_resonation/create_resonation.dart';

class ExpressionOpenBottom extends StatefulWidget {
  const ExpressionOpenBottom(this.expression);

  final CentralizedExpressionResponse expression;

  @override
  State<StatefulWidget> createState() => ExpressionOpenBottomState();
}

class ExpressionOpenBottomState extends State<ExpressionOpenBottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffeeeeee), width: .75),
        ),
      ),
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 15),
      child: Column(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  MaterialLocalizations.of(context).formatFullDate(
                    widget.expression.createdAt ?? DateTime.now(),
                  ),
                  style: const TextStyle(
                      fontSize: 10, color: JuntoPalette.juntoSleek),
                ),

                GestureDetector(
                  onTap: () {
                    _buildResonationModal();
                  },
                  child: Image.asset(
                    'assets/images/junto-mobile__resonation.png',
                    height: 17,
                    color: Color(0xff555555),
                  ),
                ),
              ]),
        ],
      ),
    );
  }

  _buildResonationModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: Color(0xff737373),
        child: Container(
          height: MediaQuery.of(context).size.height * .3,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 5,
                        width: MediaQuery.of(context).size.width * .1,
                        decoration: BoxDecoration(
                            color: Color(0xffeeeeee),
                            borderRadius: BorderRadius.circular(100)),
                      ),
                    ],
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/junto-mobile__resonation.png',
                          height: 17,
                          color: Color(0xff555555),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Resonate',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              CreateResonation(expression: widget.expression),
                        ),
                      );
                    },
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.edit,
                          size: 17,
                          color: Color(0xff555555),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Resonate with comment',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    color: Color(0xffeeeeee),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
