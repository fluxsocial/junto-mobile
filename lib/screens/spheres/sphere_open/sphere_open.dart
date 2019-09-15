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
        child: SphereOpenAppbar(
          widget.sphereHandle,
        ),
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
      // floatingActionButton: ValueListenableBuilder<bool>(
      //     valueListenable: isVisible,
      //     builder: (BuildContext context, bool value, _) {
      //       return AnimatedOpacity(
      //         duration: const Duration(milliseconds: 300),
      //         opacity: value ? 1.0 : 0,
      //         child: Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: CreateFAB(
      //             sphereHandle: widget.sphereHandle,
      //             isVisible: isVisible,
      //           ),
      //         ),
      //       );
      //     }),
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
                  width: 1,
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
                              style: JuntoStyles.header),
                        ),
                        Container(
                          child: Text(widget.sphereMembers + ' members',
                              style: JuntoStyles.title),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  child: Text(widget.sphereDescription,
                      textAlign: TextAlign.start, style: JuntoStyles.body),
                ),
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
