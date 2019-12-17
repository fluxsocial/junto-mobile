import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/widgets/expression_action_items.dart';

class ExpressionOpenTop extends StatelessWidget {
  const ExpressionOpenTop({Key key, this.expression}) : super(key: key);

  final CentralizedExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute<dynamic>(
                  builder: (BuildContext context) => JuntoMember(
                    profile: expression.creator,
                  ),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              child: Row(children: <Widget>[
                // profile picture
                ClipOval(
                  child: Image.asset(
                    'assets/images/junto-mobile__placeholder--member.png',
                    height: 45.0,
                    width: 45.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),

                // profile name and handle
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(expression.creator.username.toLowerCase() ?? '',
                          style: Theme.of(context).textTheme.subhead),
                      Text('${expression.creator.name}',
                          style: Theme.of(context).textTheme.body1),
                    ],
                  ),
                ),
              ]),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) => ExpressionActionItems(),
              );
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(5),
              alignment: Alignment.centerRight,
              child: Icon(
                CustomIcons.morevertical,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
