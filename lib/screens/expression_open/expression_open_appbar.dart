import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/models/expression.dart';

class ExpressionOpenAppbar extends StatelessWidget {
  const ExpressionOpenAppbar({this.expression});

  final CentralizedExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      brightness: Brightness.light,
      iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
      elevation: 0,
      titleSpacing: 0,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                color: Colors.transparent,
                width: 42,
                alignment: Alignment.centerLeft,
                child: Icon(CustomIcons.back,
                    size: 17, color: Theme.of(context).primaryColorDark),
              ),
            ),
            // GestureDetector(
            //   onTap: () {
            //     showModalBottomSheet(
            //       isScrollControlled: true,
            //       context: context,
            //       builder: (BuildContext context) {
            //         return ExpressionOpenContext(expression);
            //       },
            //     );
            //   },
            //   child: Container(
            //     color: Colors.transparent,
            //     padding: const EdgeInsets.only(right: 10),
            //     margin: const EdgeInsets.only(right: 20),
            //     width: 42,
            //     alignment: Alignment.centerRight,
            //     child: Icon(
            //       CustomIcons.collective,
            //       size: 10,
            //       color: Theme.of(context).primaryColorDark,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(.75),
        child: Container(
          height: .75,
          decoration: BoxDecoration(color: Theme.of(context).dividerColor),
        ),
      ),
    );
  }
}

class ExpressionOpenContext extends StatelessWidget {
  const ExpressionOpenContext(this.expression);
  final CentralizedExpressionResponse expression;

  Widget _contextIcon(BuildContext context, String contextType) {
    if (contextType == 'collective') {
      return Container(
        width: 45,
        child: Icon(CustomIcons.collective,
            color: Theme.of(context).primaryColor, size: 10),
      );
    } else if (contextType == 'channels') {
      return Container(
        width: 45,
        alignment: Alignment.center,
        child: Icon(CustomIcons.hash,
            color: Theme.of(context).primaryColor, size: 17),
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * .4,
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
          children: <Widget>[
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                _contextIcon(context, expression.context),
                const SizedBox(width: 10),
                Text('shared to ' + expression.context,
                    style: Theme.of(context).textTheme.caption)
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                _contextIcon(context, 'channels'),
                const SizedBox(width: 10),
                Flexible(
                    child: Text('tagged in no channels',
                        style: Theme.of(context).textTheme.caption))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
