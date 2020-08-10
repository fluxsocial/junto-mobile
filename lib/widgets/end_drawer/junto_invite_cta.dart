import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/app/palette.dart';

class JuntoInviteCTA extends StatelessWidget {
  const JuntoInviteCTA({
    Key key,
    @required this.callToAction,
    @required this.title,
  }) : super(key: key);

  final VoidCallback callToAction;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xff222222).withOpacity(.2),
              offset: const Offset(0.0, 5.0),
              blurRadius: 9,
            ),
          ],
        ),
        child: FlatButton(
          color: Theme.of(context).colorScheme.primary,
          onPressed: callToAction,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 30.0,
            ),
            child: Text(
              title,
              style: TextStyle(
                letterSpacing: 1.7,
                color: JuntoPalette().juntoWhite(theme: theme),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    });
  }
}
