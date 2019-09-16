import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/components/expression_preview/expression_preview.dart';
import 'package:junto_beta_mobile/components/create_fab/create_fab.dart';
import 'package:junto_beta_mobile/components/utils/hide_fab.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_open/sphere_open_appbar/sphere_open_appbar.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';

class SphereOpen extends StatefulWidget {
  const SphereOpen({
    Key key,
    @required this.sphereTitle,
    @required this.sphereImage,
    @required this.sphereMembers,
    @required this.sphereHandle,
    @required this.sphereDescription,
  }) : super(key: key);

  final String sphereTitle;
  final String sphereImage;
  final String sphereMembers;
  final String sphereHandle;
  final String sphereDescription;

  @override
  State<StatefulWidget> createState() {
    return SphereOpenState();
  }
}

class SphereOpenState extends State<SphereOpen> with HideFab {
  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);

  List<Expression> expressions = [
    Expression(
      expression: ExpressionContent(
        address: '0xfee32zokie8',
        expressionType: 'photo',
        expressionContent: <String, String>{
          'image': 'assets/images/junto-mobile__stillmind.png',
        },
      ),
      authorUsername: Username(
        address: '02efredffdfvdbnrtg',
        username: 'sunyata',
      ),
      authorProfile: UserProfile(
        address: '0vefoiwiafjvkbr32r243r5',
        firstName: 'Eric',
        lastName: 'Yang',
        profilePicture: 'assets/images/junto-mobile__eric.png',
        bio: 'hellooo',
        parent: 'parent-address',
        verified: true,
      ),
      subExpressions: <Expression>[],
      resonations: <dynamic>[],
      timestamp: '22',
      channels: <Channel>[
        Channel(
          address: 'channel-address',
          value: 'design',
          attributeType: 'Channel',
        ),
        Channel(
          address: 'channel-address',
          value: 'tech',
          attributeType: 'Channel',
        ),
      ],
    ),
    Expression(
      expression: ExpressionContent(
        address: '0xfee32zokie8',
        expressionType: 'event',
        expressionContent: <String, String>{
          'title':
              'Philosophical exchange for individual and mutual improvement',
          'location': 'Tubestation, New Polzeath UK',
          'time': 'Sun, Sep 15, 3:00PM',
          'image': 'assets/images/junto-mobile__event.png',
          'description':
              'Join us for an afternoon of deep introspection, interconnectivity, and philosophical discourse! Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum'
        },
      ),
      authorProfile: UserProfile(
        address: '0vefoiwiafjvkbr32r243r5',
        parent: 'parent-address',
        bio: 'hellooo',
        firstName: 'Eric',
        lastName: 'Yang',
        profilePicture: 'assets/images/junto-mobile__eric.png',
        verified: true,
      ),
      authorUsername: Username(
        address: '02efredffdfvdbnrtg',
        username: 'sunyata',
      ),
      subExpressions: <Expression>[],
      resonations: <dynamic>[],
      timestamp: '17',
      channels: <Channel>[
        Channel(
          address: 'channel-address',
          value: 'design',
          attributeType: 'Channel',
        ),
        Channel(
          address: 'channel-address',
          value: 'tech',
          attributeType: 'Channel',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: SphereOpenAppbar(widget.sphereHandle, widget.sphereImage),
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _isVisible,
        builder: (BuildContext context, bool visible, Widget child) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: visible ? 1.0 : 0.0,
            child: child,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CreateFAB(
            sphereHandle: widget.sphereHandle,
            isVisible: _isVisible,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: ListView(
        children: <Widget>[
          Container(
            constraints: const BoxConstraints.expand(height: 200),
            child: Image.asset(
              widget.sphereImage,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: JuntoStyles.horizontalPadding,
              vertical: 15,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: JuntoPalette.juntoFade,
                  width: .75,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(widget.sphereTitle,
                              style: TextStyle(
                                  color: JuntoPalette.juntoGrey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        JuntoPalette.juntoSecondary,
                        JuntoPalette.juntoPrimary
                      ]),
                      borderRadius: BorderRadius.circular(10)),

                  child: Text(
                    'Join Sphere',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            ClipOval(
                              child: Image.asset(
                                'assets/images/junto-mobile__eric.png',
                                height: 28.0,
                                width: 28.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 5),
                            ClipOval(
                              child: Image.asset(
                                'assets/images/junto-mobile__riley.png',
                                height: 28.0,
                                width: 28.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 5),
                            ClipOval(
                              child: Image.asset(
                                'assets/images/junto-mobile__yaz.png',
                                height: 28.0,
                                width: 28.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 5),
                            ClipOval(
                              child: Image.asset(
                                'assets/images/junto-mobile__josh.png',
                                height: 28.0,
                                width: 28.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 5),
                            ClipOval(
                              child: Image.asset(
                                'assets/images/junto-mobile__eric.png',
                                height: 28.0,
                                width: 28.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 5),
                            ClipOval(
                              child: Image.asset(
                                'assets/images/junto-mobile__riley.png',
                                height: 28.0,
                                width: 28.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 5),
                            ClipOval(
                              child: Image.asset(
                                'assets/images/junto-mobile__yaz.png',
                                height: 28.0,
                                width: 28.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 5),
                            ClipOval(
                              child: Image.asset(
                                'assets/images/junto-mobile__josh.png',
                                height: 28.0,
                                width: 28.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Container(
                          child: Text(widget.sphereMembers + ' members',
                              style: JuntoStyles.title),
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: Text(widget.sphereDescription,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15, height: 1.4)),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: JuntoPalette.juntoFade,
                  width: .75,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Principles', style: JuntoStyles.header),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * .88,
                        child: const Text(
                            'Help maintain an awesome, respectful community!'),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        size: 20,
                        color: Color(0xff555555),
                      )
                    ]),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: JuntoPalette.juntoFade,
                  width: .75,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Facilitators', style: JuntoStyles.header),
                          const SizedBox(height: 10),
                          const Text('Eric Yang and 7 others'),
                        ]),
                    ClipOval(
                      child: Image.asset(
                        'assets/images/junto-mobile__eric.png',
                        height: 45.0,
                        width: 45.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              ExpressionPreview(expression: expressions[0]),
              ExpressionPreview(expression: expressions[1]),
            ],
          )
        ],
      ),
    );
  }
}
