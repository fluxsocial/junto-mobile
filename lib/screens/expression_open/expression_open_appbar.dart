import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';

class ExpressionOpenAppbar extends StatelessWidget {
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
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return ExpressionOpenContext();
                  },
                );
              },
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(right: 10),
                width: 42,
                alignment: Alignment.centerRight,
                child: Icon(
                  CustomIcons.enso,
                  size: 20,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            )
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
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * .5,
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
                        Theme.of(context).colorScheme.primary
                      ],
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(
                    CustomIcons.enso,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
                const SizedBox(width: 10),
                Text("shared to 'Collective'",
                    style: Theme.of(context).textTheme.caption)
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: <Widget>[
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
                        Theme.of(context).colorScheme.primary
                      ],
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(
                    CustomIcons.hash,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                      'tagged in #sustainability, #permaculture, #design',
                      style: Theme.of(context).textTheme.caption),
                )
              ],
            ),
            const SizedBox(height: 25),
            Text(
              'Intention',
              style: Theme.of(context).textTheme.subhead,
            ),
            const SizedBox(height: 10),
            Text(
              'Looking for feedback!',
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      ),
    );
  }
}
