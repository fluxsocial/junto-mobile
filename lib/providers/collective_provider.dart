import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/den_model.dart';
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

  /// Fetches a list of [Expression]s from the server which matches the params.
  /// Zome: `Expression`, function: `query_expressions`, Args: `{ expression: {expression object data}, attributes: [array of attributes (channels)], context: [array of context(s) addresses] }`
  Future<List<ExpressionContent>> filterExpression(String params);

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
    ExpressionContent expression,
    String parentAddress,
  );

  /// Checks whether the given user is the owner of the passed collective.
  Future<bool> isCollectiveOwner(String collectiveAddress, String userAddress);

  /// Returns a list containing the user's dens. The method returns
  /// Dens in the order `public`, `private` and `shared`.
  Future<List<Den>> getUserDen(String usernameAddress);

  List<Expression> get collectiveExpressions;

  Expression get sampleExpression;
}

class CollectiveProviderImpl with ChangeNotifier implements CollectiveProvider {
  /// Like all holo functions, we need to call a `zome` and pass the
  /// parameters as args to create a new expression.
  @override
  Future<void> createExpression(Expression expression) async {
    final Expression sampleExpression = collectiveExpressions.first;
    final Map<String, dynamic> expressionBody = JuntoHttp.holobody(
      'post_expression',
      'expression',
      <String, dynamic>{
        'expression': sampleExpression.expression.toMap(),
        'attributes': sampleExpression.channels,
        'context': <String>['QmTodLQKwfLd4pxTkjvAdyaEoqNaJnq12cRPXu2aPx4xbz'],
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
  Future<List<ExpressionContent>> filterExpression(String params) async {
    // Body to be sent to holochain
    final Map<String, dynamic> postBody = JuntoHttp.holobody(
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
        'seed': randomString(),
      },
    );
    try {
      final http.Response response =
          await JuntoHttp().post('/holochain', body: postBody);
      // Holochain only sends 200 responses...even for errors
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody =
            deserializeHoloJson(response.body);

        // Should there be no error, the results will contain an `Ok` key.
        if (responseBody['Ok']) {
          final List<ExpressionContent> results = <ExpressionContent>[];
          for (final Map<String, dynamic> response in responseBody['Ok']) {
            final ExpressionContent content =
                ExpressionContent.fromMap(response);
            results.add(content);
          }
          return results;
        }

        // Should the response from holochain contain an error, the key `Err`
        // will exist.
        if (responseBody['Err']) {
          throw Exception('Error querying  ${responseBody['Err']}');
        }
      }
    } on HttpException catch (error) {
      debugPrint('HTTPEXCEPTION has occured $error');
    }
    return null;
  }

  @override
  Future<String> createCollection(
      Map<String, String> collectionData, String collectionTag) {
    final Map<String, dynamic> mapBody = JuntoHttp.holobody(
      'create_collection',
      'collection',
      <String, dynamic>{
        'collection': collectionData,
        'collection_tag': collectionTag,
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
    final Map<String, dynamic> postBody = JuntoHttp.holobody(
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
        final dynamic response = deserializeHoloJson(serverResponse.body);
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

  @override
  Future<String> postCommentExpression(
      ExpressionContent expression, String parentAddress) async {
    final Map<String, dynamic> postBody = JuntoHttp.holobody(
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
            deserializeHoloJson(response.body);
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

  @override
  Future<bool> isCollectiveOwner(
      String collectiveAddress, String userAddress) async {
    final Map<String, dynamic> _body = JuntoHttp.holobody(
      'is_collection_owner',
      'collective',
      <String, dynamic>{
        'collection': collectiveAddress,
        'username_address': userAddress,
      },
    );
    try {
      final http.Response _serverResponse =
          await JuntoHttp().post('/holochain', body: _body);
      final bool isOwner =
          JuntoHttp.handleResponse(_serverResponse) as String == 'true';
      return isOwner;
    } on HttpException catch (error) {
      debugPrint('Error in isCollectiveOwner $error');
      rethrow;
    }
  }

  @override
  Future<List<Den>> getUserDen(String usernameAddress) async {
    Den privateDen;
    Den publicDen;
    Den sharedDen;
    final Map<String, dynamic> _body = JuntoHttp.holobody(
      'get_user_dens',
      'collective',
      <String, dynamic>{'username_address': usernameAddress},
    );
    try {
      final http.Response _serverResponse =
          await JuntoHttp().post('/holochain', body: _body);

      // The decoded `Ok` response contains a Map with the keys `private_den`, `shared_den` and `public_den`
      // Each Den is a map containing `address`, `entry` (Map containing `parent`), `name`, `privacy` and `channel_type`
      final Map<String, dynamic> decodedResponse =
          JuntoHttp.handleResponse(_serverResponse);

      // A user user may not be part of all 3 Den types. We check for the presence of the different keys before
      // assigning the variables.
      if (decodedResponse['private_den']) {
        privateDen = Den.fromMap(decodedResponse['private_den']);
      }
      if (decodedResponse['public_den']) {
        publicDen = Den.fromMap(decodedResponse['public_den']);
      }
      if (decodedResponse['shared_den']) {
        sharedDen = Den.fromMap(decodedResponse['shared_den']);
      }
      return <Den>[publicDen, privateDen, sharedDen];
    } on HttpException catch (error) {
      debugPrint('Error in getUserDen $error');
      rethrow;
    }
  }

  final List<Perspective> _perspectives = <Perspective>[];

  @override
  Expression get sampleExpression => Expression(
        expression: ExpressionContent(
          address: '',
          expressionType: 'longform',
          expressionContent: <String, String>{
            'title': 'Testing',
            'body': 'Hellos this is test data'
          },
        ),
        subExpressions: <Expression>[],
        authorUsername: Username(
          address: 'QmWieBF1pJzPX6dusE45nkkvzP3jpGiLpAWRuNu9pzY17k',
          username: 'Nash',
        ),
        authorProfile: UserProfile(
          address: 'QmXe4zPtBUHCG6gCUUJKGyCrFeLpZCtv3HwA2z7wswGqc8',
          parent: 'QmWieBF1pJzPX6dusE45nkkvzP3jpGiLpAWRuNu9pzY17k',
          bio: 'Henlo',
          firstName: 'Nash',
          lastName: 'Ramdial',
          profilePicture: 'assets/images/junto-mobile__eric.png',
          verified: true,
        ),
        resonations: <dynamic>[],
        timestamp: '2',
        channels: <Channel>[],
      );

  @override
  List<Expression> get collectiveExpressions {
    return _collectiveExpressions;
  }

  List<Perspective> get perspectives {
    return _perspectives;
  }

  /// Generates a random string used as a seed to query expressions.
  String randomString() {
    final Random _random = Random.secure();
    final List<int> values = List<int>.generate(
      25,
      (int i) => _random.nextInt(256),
    );

    return base64Url.encode(values);
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
        expressionType: 'event',
        expressionContent: <String, String>{
          'title': 'Ecstatic Dance - Movement to Fill Your Soul',
          'location': 'Tubestation, New Polzeath UK',
          'time': 'SUN, SEP 15, 6:00PM',
          'image': '',
          'description': 'Get ready to get groovy!'
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
    Expression(
      expression: ExpressionContent(
        address: '0xfee32zokie8',
        expressionType: 'photo',
        expressionContent: <String, String>{
          'image': 'assets/images/junto-mobile__kevin.png',
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
}
