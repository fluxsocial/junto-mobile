import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/app/palette.dart';

class SignInBackNav extends StatelessWidget {
  SignInBackNav({this.signInController});

  final PageController signInController;
  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Row(
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                signInController.previousPage(
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 300),
                );
                if (FocusScope.of(context).hasFocus) {
                  FocusScope.of(context).unfocus();
                }
              },
              child: Container(
                width: 38,
                height: 38,
                alignment: Alignment.centerLeft,
                child: Icon(
                  CustomIcons.back,
                  color:
                      JuntoPalette().juntoWhite(theme: theme).withOpacity(.70),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
