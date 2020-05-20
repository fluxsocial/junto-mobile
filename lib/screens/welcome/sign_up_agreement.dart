import 'package:flutter/material.dart';

import 'widgets/junto_logo.dart';
import 'widgets/junto_name.dart';
import 'widgets/junto_rules.dart';
import 'widgets/junto_terms.dart';
import 'widgets/sign_up_accept_button.dart';

/// Agreements screen shown to the user following registration
class SignUpAgreements extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpAgreementsState();
  }
}

class SignUpAgreementsState extends State<SignUpAgreements> {
  int _currentIndex = 0;
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  _nextPage() {
    pageController.nextPage(
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 300),
    );
  }

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
            children: <Widget>[
              JuntoLogo(),
              JuntoName(),
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  children: <Widget>[
                    JuntoRules(),
                    JuntoTerms(),
                  ],
                ),
              ),
              AcceptButton(
                nextPage: _nextPage,
                pageView: _currentIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
