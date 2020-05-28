import 'package:flutter/material.dart';

import 'widgets/junto_logo.dart';
import 'widgets/junto_name.dart';
import 'widgets/junto_rules.dart';
import 'widgets/sign_up_accept_button.dart';

/// Agreements screen shown to the user following registration
class SignUpAgreements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * .1,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              JuntoLogo(),
              JuntoName(),
              Expanded(
                child: JuntoRules(),
              ),
              AcceptButton(),
            ],
          ),
        ),
      ),
    );
  }
}
