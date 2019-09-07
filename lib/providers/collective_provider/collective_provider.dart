import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:junto_beta_mobile/utils/utils.dart';

/// Interface which defines the roles and functionality of the
/// CollectiveProvider.
abstract class CollectiveProvider with ChangeNotifier {
  /// Creates an expression on the server.  Method requires the [Expression]
  /// to be created.
  /// Zome: `Expression` function: `post_expression` args: `{ expression: {expression object data}, attributes: [array of attributes (channels)], context: [array of context(s) addresses] }`
  Future<void> createExpression(Expression expression);

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

  /// Allows a user to resonate with a particular expression.
  /// Function requires the address of the Expression as the only argument.
  Future<void> postResonation(String address);

  ///Allows for the posting of comment expressions. The [ExpressionContent] and address of the
  ///parent [Expression] must be supplied to the function.
  Future<String> postCommentExpression(
      ExpressionContent expression, String parentAddress);

  List<Expression> get collectiveExpressions;
}

class CollectiveProviderImpl with ChangeNotifier implements CollectiveProvider {
  /// Like all holo functions, we need to call a `zome` and pass the
  /// parameters as args to create a new expression.
  @override
  Future<void> createExpression(Expression expression) async {
    final Expression sampleExpression = collectiveExpressions.first;
    final Map<String, dynamic> expressionBody = holobody(
      'post_expression',
      'expression',
      <String, dynamic>{
        'expression': sampleExpression.expression.toMap(),
        'attributes': sampleExpression.channels,
        'context': <String>['testing'],
      },
    );
    try {
      final http.Response response = await JuntoHttp().post(
        '/holochain',
        body: expressionBody,
      );
      debugPrint('Response from HOLOCHAIN ${response.body}');
    } on HttpException catch (error) {
      debugPrint('Error posting expression $error');
    }
  }

  @override
  Future<List<Expression>> filterExpression(String params) {
    final Map<String, dynamic> postBody = holobody(
      'query_expressions',
      'expression',
      <String, dynamic>{
        'perspective': 'dos',
        'attributes': <String>[
          'default',
        ],
        'query_options': 'Or',
        'target_type': '',
        'query_type': 'ExpressionPost',
        'dos': '6',
        'seed': 'string-to-randomize-searching',
      },
    );
    JuntoHttp().post('/holochain', body: postBody);
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
    final Map<String, dynamic> mapBody = holobody(
      'create_collection',
      'collection',
      <String, dynamic>{
        'collection': <String, dynamic>{},
        'collection_tag': 'type-of-collection',
      },
    );
    try {
      JuntoHttp().post('/holochain', body: mapBody);
    } on HttpException catch (error) {
      debugPrint('Error creating collection $error');
    }
    return null;
  }

  @override
  Future<void> postResonation(String address) async {
    final Map<String, dynamic> postBody = holobody(
      'post_resonation',
      'expression',
      <String, dynamic>{
        'collection': <String, dynamic>{},
        'collection_tag': 'type-of-collection',
      },
    );
    try {
      final http.Response serverResponse = await JuntoHttp().post(
        '/holochain',
        body: postBody,
      );
      if (serverResponse.statusCode == 200) {
        final dynamic response =
            deserializeJsonRecursively(serverResponse.body);
        print(response);
      } else {
        throw const HttpException(
          'postResonation: Holochain returned an '
          'status code != 200',
        );
      }
    } on HttpException catch (error) {
      debugPrint('Error adding resonnation $error');
    }
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

  @override
  Future<String> postCommentExpression(
      ExpressionContent expression, String parentAddress) async {
    final Map<String, dynamic> postBody = holobody(
      'post_comment_expression',
      'expression',
      <String, dynamic>{
        'expression': expression.toMap(),
        'parent_expression': parentAddress,
      },
    );
    try {
      final http.Response response =
          await JuntoHttp().post('/holochain', body: postBody);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody =
            deserializeJsonRecursively(response.body);
        if (responseBody['Ok']) {
          return responseBody['Ok'];
        }
        if (responseBody['Err']) {
          throw Exception('Server returned error ${responseBody['Err']}');
        }
      } else {
        throw Exception('Server returned status code != 200');
      }
    } on HttpException catch (error) {
      debugPrint('HTTP ERROR POSTING COMMENT: $error');
    }
    return null;
  }

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

Map<String, dynamic> holobody(
    String functionName, String zome, Map<String, dynamic> args) {
  return <String, dynamic>{
    'zome': zome,
    'function': functionName,
    'args': args
  };
}
