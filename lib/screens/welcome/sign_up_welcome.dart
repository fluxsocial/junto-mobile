import 'package:flutter/material.dart';

/// Agreements screen shown to the user following registration
class SignUpAgreements extends StatefulWidget {
  const SignUpAgreements({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SignUpAgreementsState();
}

class SignUpAgreementsState extends State<SignUpAgreements> {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    child: Image.asset(
                        'assets/images/junto-mobile__outlinelogo--gradient.png',
                        height: 69,
                        color: Theme.of(context).primaryColor),
                  ),
                  // Container(
                  //   width: MediaQuery.of(context).size.width * .5,
                  //   margin: const EdgeInsets.only(bottom: 25),
                  //   decoration: BoxDecoration(
                  //     border: Border(
                  //       bottom: BorderSide(
                  //         color: Theme.of(context).dividerColor,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   padding: EdgeInsets.symmetric(
                  //       horizontal: MediaQuery.of(context).size.width * .05),
                  //   margin: const EdgeInsets.only(bottom: 25),
                  //   child: Text(
                  //     'Junto Community Agreements',
                  //     style: TextStyle(
                  //         color: Theme.of(context).primaryColorDark,
                  //         fontWeight: FontWeight.w700,
                  //         fontSize: 22),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
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
                        horizontal: MediaQuery.of(context).size.width * .05),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 15),
                          // decoration: BoxDecoration(
                          //   border: Border(
                          //     left: BorderSide(
                          //         color: Theme.of(context).dividerColor,
                          //         width: 2),
                          //   ),
                          // ),
                          child: Text(
                            '1. Be aware of the impact your words and actions have. Embrace kindness and compassion when interacting with others.',
                            style: Theme.of(context).textTheme.caption,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          padding: const EdgeInsets.only(left: 15),
                          // decoration: BoxDecoration(
                          //   border: Border(
                          //     left: BorderSide(
                          //         color: Theme.of(context).dividerColor,
                          //         width: 2),
                          //   ),
                          // ),
                          child: Text(
                            '2. Accept everyone else\'s experience as valid, even if it doesn\'t look like yours',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          padding: const EdgeInsets.only(left: 15),
                          // decoration: BoxDecoration(
                          //   border: Border(
                          //     left: BorderSide(
                          //         color: Theme.of(context).dividerColor,
                          //         width: 2),
                          //   ),
                          // ),
                          child: Text(
                            '3. Expresson yourself freely. Be real and hold space for authenticity.',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                  onPressed: () {},
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  color: Colors.transparent,
                  elevation: 0,
                  child: const Text(
                    'I\'M IN',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 1.4),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
