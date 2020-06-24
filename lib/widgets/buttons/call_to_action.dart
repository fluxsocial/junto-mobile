import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/app/palette.dart';

class CallToActionButton extends StatelessWidget {
  const CallToActionButton({
    Key key,
    @required this.callToAction,
    @required this.title,
    this.transparent = false,
  }) : super(key: key);

  final VoidCallback callToAction;
  final String title;
  final bool transparent;

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        decoration: transparent
            ? null
            : BoxDecoration(
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
          color: transparent ? null : Theme.of(context).accentColor,
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
