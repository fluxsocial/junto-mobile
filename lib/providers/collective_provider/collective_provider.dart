import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/perspective.dart';

class CollectiveProvider with ChangeNotifier {
  final List<ExpressionResult> _collectiveExpressions = <ExpressionResult>[
    ExpressionResult(
      result: <Expression>[
        Expression(
          expression: ExpressionContent(
            address: '0xfee32zokie8',
            expressionType: 'longform',
            expressionContent: <String, String>{
              'title': 'The Medium is the Message',
              'body': 'Hellos my name is Urk'
            },
          ),
          subExpressions: <Expression>[],
          authorUsername: AuthorUsername(
            address: '02efredffdfvdbnrtg',
            username: 'sunyata',
          ),
          authorProfile: AuthorProfile(
            address: '0vefoiwiafjvkbr32r243r5',
            parent: 'parent-address',
            bio: 'hellooo',
            firstName: 'Eric',
            lastName: 'Yang',
            profilePicture: 'assets/images/junto-mobile__eric.png',
            verified: true,
          ),
          resonations: <dynamic>[],
          timestamp: '2',
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
      ],
    ),
    ExpressionResult(
      result: <Expression>[
        Expression(
          expression: ExpressionContent(
            address: '0xfee32zokie8',
            expressionType: 'shortform',
            expressionContent: <String, String>{
              'body': 'Junto is releasing September 28th. Mark your calendars!',
              'background': 'three'
            },
          ),
          authorProfile: AuthorProfile(
            address: '0vefoiwiafjvkbr32r243r5',
            parent: 'parent-address',
            bio: 'hellooo',
            firstName: 'Eric',
            lastName: 'Yang',
            profilePicture: 'assets/images/junto-mobile__eric.png',
            verified: true,
          ),
          authorUsername: AuthorUsername(
            address: '02efredffdfvdbnrtg',
            username: 'sunyata',
          ),
          subExpressions: <Expression>[],
          resonations: <dynamic>[],
          timestamp: '7',
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
      ],
    ),
    ExpressionResult(
      result: <Expression>[
        Expression(
          expression: ExpressionContent(
            address: '0xfee32zokie8',
            expressionType: 'shortform',
            expressionContent: <String, String>{
              'body': 'Hello cats!',
              'background': 'four'
            },
          ),
          authorUsername: AuthorUsername(
            address: '02efredffdfvdbnrtg',
            username: 'yaz',
          ),
          authorProfile: AuthorProfile(
            address: '0vefoiwiafjvkbr32r243r5',
            firstName: 'Yaz',
            lastName: 'Owainati',
            profilePicture: 'assets/images/junto-mobile__yaz.png',
            bio: 'hellooo',
            parent: 'parent-address',
            verified: true,
          ),
          subExpressions: <Expression>[],
          resonations: <dynamic>[],
          timestamp: '8',
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
      ],
    ),
    ExpressionResult(result: <Expression>[
      Expression(
        expression: ExpressionContent(
          address: '0xfee32zokie8',
          expressionType: 'longform',
          expressionContent: <String, String>{
            'title': 'Coming from the UK!',
            'body': 'Hellos my name is josh'
          },
        ),
        subExpressions: <Expression>[],
        timestamp: '4',
        authorProfile: AuthorProfile(
          address: '0vefoiwiafjvkbr32r243r5',
          parent: 'parent-address',
          firstName: 'Josh',
          lastName: 'Parkin',
          profilePicture: 'assets/images/junto-mobile__josh.png',
          verified: true,
          bio: 'hellooo',
        ),
        authorUsername: AuthorUsername(
          address: '02efredffdfvdbnrtg',
          username: 'jdeepee',
        ),
        resonations: <dynamic>[],
        channels: <Channel>[
          Channel(
            address: 'channel-address',
            value: 'tech',
            attributeType: 'Channel',
          ),
        ],
      ),
    ]),
  ];

  final List<Perspective> _perspectives = <Perspective>[];

  List<ExpressionResult> get collectiveExpressions {
    return _collectiveExpressions;
  }

  List<Perspective> get perspectives {
    return _perspectives;
  }

  void addCollectiveExpression() {
    notifyListeners();
  }
}
