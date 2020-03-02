import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/screens/lotus/lotus.dart';

/// Agreements screen shown to the user following registration
class SignUpAgreements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * .15,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Image.asset(
                          'assets/images/junto-mobile__outlinelogo--gradient.png',
                          height: 69,
                          color: Theme.of(context).primaryColor),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * .05),
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Text(
                        'JUNTO',
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w400,
                            fontSize: 28,
                            letterSpacing: 1.8),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .5,
                      margin: const EdgeInsets.only(bottom: 40),
                      decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Theme.of(context)
                                    .primaryColorDark
                                    .withOpacity(.12),
                                offset: const Offset(0.0, 6.0),
                                blurRadius: 9),
                          ]),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * .1),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Text(
                              '1. Be aware of the impact your words and actions have. Embrace kindness and compassion when interacting with others.',
                              style: Theme.of(context).textTheme.headline5,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const SizedBox(height: 25),
                          Container(
                            child: Text(
                              '2. Accept everyone else\'s experience as valid, even if it doesn\'t look like yours',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          const SizedBox(height: 25),
                          Container(
                            child: Text(
                              '3. Expresson yourself freely. Be real and hold space for authenticity.',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 50),
                width: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const <double>[0.1, 0.9],
                    colors: <Color>[
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.primary
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                    100,
                  ),
                ),
                child: RaisedButton(
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder<dynamic>(
                        pageBuilder: (
                          BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                        ) {
                          return const JuntoLotus(
                            address: null,
                            expressionContext: ExpressionContext.Collective,
                          );
                        },
                        transitionsBuilder: (
                          BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child,
                        ) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(
                          milliseconds: 1000,
                        ),
                      ),
                    );
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  color: Colors.transparent,
                  elevation: 0,
                  child: const Text(
                    'COUNT ME IN',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 1.4),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
