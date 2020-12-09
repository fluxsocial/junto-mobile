import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/app/palette.dart';

class SignUpArrows extends StatelessWidget {
  const SignUpArrows({
    Key key,
    @required this.currentIndex,
    @required this.onTap,
    @required this.previousPage,
  });

  final int currentIndex;
  final VoidCallback onTap;
  final Function previousPage;

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      return Positioned(
        bottom: MediaQuery.of(context).size.height * .05,
        right: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (currentIndex <= 6)
              Container(
                child: GestureDetector(
                  onTap: () async {
                    previousPage();
                  },
                  child: Container(
                    height: 36,
                    width: 36,
                    color: Colors.transparent,
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: JuntoPalette()
                          .juntoWhite(theme: theme)
                          .withOpacity(.3),
                      size: 36,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (currentIndex != 6)
              GestureDetector(
                onTap: onTap,
                child: Container(
                  height: 36,
                  width: 36,
                  color: Colors.transparent,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: JuntoPalette().juntoWhite(theme: theme),
                    size: 36,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
