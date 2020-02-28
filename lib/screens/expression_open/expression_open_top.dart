import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/expression_action_items.dart';

class ExpressionOpenTop extends StatelessWidget with MemberValidation {
  const ExpressionOpenTop({Key key, this.expression, this.userAddress})
      : super(key: key);

  final ExpressionResponse expression;
  final String userAddress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () => showUserDen(context, expression.creator),
            child: Container(
              color: Colors.transparent,
              child: Row(children: <Widget>[
                if (expression.creator.profilePicture.isNotEmpty)
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: expression.creator.profilePicture[0],
                      height: 45,
                      width: 45,
                      fit: BoxFit.cover,
                      placeholder: (BuildContext context, String _) {
                        return Container(
                          alignment: Alignment.center,
                          height: 45.0,
                          width: 45.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: const <double>[0.3, 0.9],
                              colors: <Color>[
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).colorScheme.primary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Image.asset(
                              'assets/images/junto-mobile__logo--white.png',
                              height: 17),
                        );
                      },
                    ),
                  ),
                if (expression.creator.profilePicture.isEmpty)
                  // profile picture
                  Container(
                    alignment: Alignment.center,
                    height: 45.0,
                    width: 45.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        stops: const <double>[0.3, 0.9],
                        colors: <Color>[
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.primary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.asset(
                        'assets/images/junto-mobile__logo--white.png',
                        height: 17),
                  ),
                const SizedBox(width: 10),

                // profile name and handle
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(expression.creator.username.toLowerCase() ?? '',
                          style: Theme.of(context).textTheme.subtitle1),
                      Text('${expression.creator.name}',
                          style: Theme.of(context).textTheme.bodyText1),
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
                builder: (BuildContext context) => ExpressionActionItems(
                    expression: expression, userAddress: userAddress),
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
