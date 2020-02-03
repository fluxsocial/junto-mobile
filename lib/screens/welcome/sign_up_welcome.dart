import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:junto_beta_mobile/screens/lotus/lotus.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

/// Agreements screen shown to the user following registration
class SignUpAgreements extends StatefulWidget {
  const SignUpAgreements({Key key, this.profilePictures}) : super(key: key);

  final List<dynamic> profilePictures;

  @override
  State<StatefulWidget> createState() => SignUpAgreementsState();
}

class SignUpAgreementsState extends State<SignUpAgreements> {
  String _userAddress;
  //ignore:unused_field
  UserData _userProfile;

  @override
  void initState() {
    super.initState();

    getUserInformation();
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData =
        jsonDecode(prefs.getString('user_data'));

    setState(() {
      _userAddress = prefs.getString('user_id');
      _userProfile = UserData.fromMap(decodedUserData);
    });
  }

//ignore:unused_element
  Future<void> _updateUserPhotos(List<dynamic> profilePictures) async {
    // check if user uploaded profile pictures
    // retrieve key and add to _photoKeys if true
    final List<String> _photoKeys = <String>[];
    for (final dynamic image in profilePictures) {
      if (image != null) {
        final String key =
            await Provider.of<ExpressionRepo>(context, listen: false)
                .createPhoto(
          false,
          '.png',
          image,
        );
        _photoKeys.add(key);
      }
    }
    Map<String, dynamic> _profilePictureKeys;

    // instantiate data structure to update user with profile pictures
    _profilePictureKeys = <String, dynamic>{
      'profile_picture': <Map<String, dynamic>>[
        <String, dynamic>{'index': 0, 'key': _photoKeys[0]},
        if (_photoKeys.length == 2)
          <String, dynamic>{'index': 1, 'key': _photoKeys[1]},
      ]
    };
    // update user with profile photos
    try {
      JuntoLoader.showLoader(context);

      await Provider.of<UserRepo>(context, listen: false).updateUser(
          profilePictures.first == null ? _photoKeys : _profilePictureKeys,
          _userAddress);
      JuntoLoader.hide();
    } catch (error) {
      print(error);
      JuntoLoader.hide();
    }
  }

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
                    // await _updateUserPhotos(widget.profilePictures);

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
              )
            ],
          ),
        ),
      ),
    );
  }
}
