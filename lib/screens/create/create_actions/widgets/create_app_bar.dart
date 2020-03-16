import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/styles.dart';

class CreateAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CreateAppBar({
    Key key,
    @required this.expressionType,
    @required this.onNext,
  }) : super(key: key);

  final ExpressionType expressionType;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(45),
      child: AppBar(
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        iconTheme: const IconThemeData(color: JuntoPalette.juntoGrey),
        elevation: 0,
        titleSpacing: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: JuntoStyles.horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(expressionType.icon(), size: 24),
                  const SizedBox(width: 7.5),
                  Text(
                    expressionType.appBarName(),
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
              InkWell(
                onTap: onNext,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                  child:
                      Text('next', style: Theme.of(context).textTheme.caption),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(45);
}
