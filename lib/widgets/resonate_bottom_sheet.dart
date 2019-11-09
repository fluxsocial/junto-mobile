import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/create_resonation/create_resonation.dart';

class ResonateBottomSheet extends StatelessWidget {
  const ResonateBottomSheet({
    Key key,
    @required this.expression,
  }) : super(key: key);

  final CentralizedExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * .3,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
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
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  title: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/junto-mobile__resonation.png',
                        height: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Resonate',
                        style: Theme.of(context).textTheme.headline,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      CupertinoPageRoute<dynamic>(
                        builder: (BuildContext context) =>
                            CreateResonation(expression: expression),
                      ),
                    );
                  },
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.edit,
                        size: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Resonate with comment',
                        style: Theme.of(context).textTheme.headline,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
