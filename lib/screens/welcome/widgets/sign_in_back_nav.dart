import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class SignInBackNav extends StatelessWidget {
  SignInBackNav({this.signInController});

  final PageController signInController;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.bottomLeft,
      child: GestureDetector(
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
            color: Colors.white70,
            size: 20,
          ),
        ),
      ),
    );
  }
}
