import 'dart:io';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';

/// Interface which defines the roles and functionality of the
/// CollectiveProvider.
abstract class CollectiveProvider with ChangeNotifier {
  /// Creates an expression on the server.  Method requires the [Expression]
  /// to be created.
  /// Zome: `Expression` function: `post_expression` args: `{ expression: {expression object data}, attributes: [array of attributes (channels)], context: [array of context(s) addresses] }`
  Future<Map<String, dynamic>> createExpression(Expression expression);

  /// Deletes the given expression from the server.
  Future<void> removeExpression(Expression expression);

  /// Fetches a list of [Expression]s from the server which matches the params.
  /// Zome: `Expression`, function: `query_expressions`, Args: `{ expression: {expression object data}, attributes: [array of attributes (channels)], context: [array of context(s) addresses] }`
  Future<List<Expression>> filterExpression(String params);

  /// Creates a collection and returns the address of the collection if the
  /// request is successful.
  Future<String> createCollection(
    Map<String, String> collectionData,
    String collectionTag,
  );

  List<Expression> get collectiveExpressions;
}

class CollectiveProviderImpl with ChangeNotifier implements CollectiveProvider {
  /// Like all holo functions, we need to call a `zome` and pass the
  /// parameters as args to create a new expression.
  @override
  Future<Map<String, dynamic>> createExpression(Expression expression) {
    // TODO: implement createExpression
    return null;
  }

  @override
  Future<List<Expression>> filterExpression(String params) {
    // TODO: implement filterExpression
    return null;
  }

  @override
  Future<void> removeExpression(Expression expression) {
    // TODO: implement removeExpression
    return null;
  }

  @override
  Future<String> createCollection(
      Map<String, String> collectionData, String collectionTag) {
    final Map<String, dynamic> mapBody = <String, dynamic>{
      'zome': 'collection',
      'function': 'create_collection',
      'args': <String, dynamic>{
        'collection': <String, dynamic>{},
        'collection_tag': 'type-of-collection',
      },
    };
    try {
      JuntoHttp().post('/holochain', body: mapBody);
    } on HttpException catch (error) {
      debugPrint('Error creating collection $error');
    }
    return null;
  }

  final List<Expression> _collectiveExpressions = <Expression>[
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
      authorUsername: Username(
        address: '02efredffdfvdbnrtg',
        username: 'sunyata',
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
    Expression(
      expression: ExpressionContent(
        address: '0xfee32zokie8',
        expressionType: 'shortform',
        expressionContent: <String, String>{
          'body': 'Junto is releasing September 28th. Mark your calendars!',
          'background': 'three'
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
    Expression(
      expression: ExpressionContent(
        address: '0xfee32zokie8',
        expressionType: 'shortform',
        expressionContent: <String, String>{
          'body': 'Hello cats!',
          'background': 'four'
        },
      ),
      authorUsername: Username(
        address: '02efredffdfvdbnrtg',
        username: 'yaz',
      ),
      authorProfile: UserProfile(
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
      authorProfile: UserProfile(
        address: '0vefoiwiafjvkbr32r243r5',
        parent: 'parent-address',
        firstName: 'Josh',
        lastName: 'Parkin',
        profilePicture: 'assets/images/junto-mobile__josh.png',
        verified: true,
        bio: 'hellooo',
      ),
      authorUsername: Username(
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
  ];

  final List<Perspective> _perspectives = <Perspective>[];

  @override
  List<Expression> get collectiveExpressions {
    return _collectiveExpressions;
  }

  List<Perspective> get perspectives {
    return _perspectives;
  }

  void addCollectiveExpression() {
    notifyListeners();
  }
}
