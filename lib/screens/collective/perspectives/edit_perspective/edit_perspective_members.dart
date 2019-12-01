import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';

class EditPerspectiveMembers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
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
                    width: 42,
                    height: 42,
                    alignment: Alignment.centerLeft,
                    color: Colors.transparent,
                    child: Icon(
                      CustomIcons.back,
                      color: Theme.of(context).primaryColorDark,
                      size: 17,
                    ),
                  ),
                ),
                Text('Members', style: Theme.of(context).textTheme.subhead),
                const SizedBox(
                  width: 42,
                  height: 42,
                )
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(.75),
            child: Container(
              height: .75,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).dividerColor, width: .75),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  _buildPerspectiveMember(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildPerspectiveMember(context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Row(
        children: <Widget>[
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
                child: Image.asset(
                    'assets/images/junto-mobile__logo--white.png',
                    height: 15),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 75,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: .5,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                margin: const EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'sunyata',
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.subhead,
                        ),
                        Text('Eric Yang',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.body1)
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // remove member from perspective
                      },
                      child: Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'x',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColor),
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
