import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/resonation_model.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';

/// Interface which defines the roles and functionality of the
/// CollectiveProvider.
abstract class CollectiveProvider {
  /// Creates an expression on the server.
  /// Method requires [CentralizedExpression] as it's only arg.
  Future<CentralizedExpressionResponse> createExpression(
    CentralizedExpression expression,
  );

  /// Returns a [CentralizedExpressionResponse] for the given address.
  Future<CentralizedExpressionResponse> getExpression(
    String expressionAddress,
  );

  /// Allows a user to resonate with the given expression.
  /// [expressionAddress] must not be null or empty.
  Future<Resonation> postResonation(
    String expressionAddress,
  );

  /// Allows the user to comment under the supplied expression.
  /// [parentAddress], [type] and [data] must be passed.
  Future<CentralizedExpressionResponse> postCommentExpression(
    String parentAddress,
    String type,
    Map<String, dynamic> data,
  );

  /// Returns a list of [UserProfile] for the users who resonated with the
  /// given [expressionAddress].
  Future<List<UserProfile>> getExpressionsResonation(
    String expressionAddress,
  );

  /// Returns a list of [Comment]s for the given [expressionAddress].
  Future<List<Comment>> getExpressionsComments(
    String expressionAddress,
  );

  /// Returns mock expression data.
  List<Expression> get collectiveExpressions;
}

/// Concrete implementation of [CollectiveProvider]
class CollectiveProviderCentralized implements CollectiveProvider {
  @override
  List<Expression> get collectiveExpressions => sampleExpressions;

  @override
  Future<CentralizedExpressionResponse> createExpression(
      CentralizedExpression expression) async {
    final Map<String, dynamic> _postBody = expression.toMap();
    final http.Response _serverResponse =
        await JuntoHttp().postWithoutEncoding('/expressions', body: _postBody);
    final Map<String, dynamic> parseData =
        JuntoHttp.handleResponse(_serverResponse);
    final CentralizedExpressionResponse response =
        CentralizedExpressionResponse.fromMap(parseData);
    return response;
  }

  @override
  Future<CentralizedExpressionResponse> postCommentExpression(
      String expressionAddress, String type, Map<String, dynamic> data) async {
    final Map<String, dynamic> _postBody = <String, dynamic>{
      'target_expression': expressionAddress,
      'type': type,
      'expression_data': data
    };
    final http.Response _serverResponse = await JuntoHttp().post(
      '/expressions/$expressionAddress/comments',
      body: _postBody,
    );
    final Map<String, dynamic> _parseResponse =
        JuntoHttp.handleResponse(_serverResponse);
    return CentralizedExpressionResponse.fromMap(_parseResponse);
  }

  @override
  Future<Resonation> postResonation(
    String expressionAddress,
  ) async {
    final http.Response _serverResponse = await JuntoHttp().post(
      '/expressions/$expressionAddress/resonations',
    );
    return Resonation.fromMap(JuntoHttp.handleResponse(_serverResponse));
  }

  @override
  Future<CentralizedExpressionResponse> getExpression(
    String expressionAddress,
  ) async {
    final http.Response _response =
        await JuntoHttp().get('/expressions/$expressionAddress');
    final Map<String, dynamic> _decodedResponse =
        JuntoHttp.handleResponse(_response);
    return CentralizedExpressionResponse.withCommentsAndResonations(
        _decodedResponse);
  }

  @override
  Future<List<Comment>> getExpressionsComments(String expressionAddress) async {
    final http.Response response =
        await JuntoHttp().get('/expressions/$expressionAddress/comments');
    final List<dynamic> _listData = json.decode(response.body);
    final List<Comment> _results = _listData
        .map((dynamic data) => Comment.fromMap(data))
        .toList(growable: false);
    return _results;
  }

  @override
  Future<List<UserProfile>> getExpressionsResonation(
      String expressionAddress) async {
    final http.Response response =
        await JuntoHttp().get('/expressions/$expressionAddress/resonations');
    final List<dynamic> _listData = json.decode(response.body);
    final List<UserProfile> _results = _listData
        .map((dynamic data) => UserProfile.fromMap(data))
        .toList(growable: false);
    return _results;
  }
}

List<Expression> sampleExpressions = <Expression>[
  Expression(
    expression: ExpressionContent(
      address: '0xfee32zokie8',
      expressionType: 'longform',
      expressionContent: <String, String>{
        'title': 'Dynamic form is in motion!',
        'body':
            "Hey! Eric here. We're currently working with a London-based dev agency called DevAngels to build out our dynamic, rich text editor. Soon, you'll be able to create short or longform expressions that contain text, links, images complemented with features such as bullet points, horiozntal lines, bold and italic font, and much more. This should be done in the next 1 or 2 weeks so stay tuned!"
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
        'body':
            'Have you heard of Paradym sound healing meditation? Join us for '
                'a transformational session this Friday!',
        'background': 'four'
      },
    ),
    authorUsername: Username(
      address: '02efredffdfvdbnrtg',
      username: 'wingedmessenger',
    ),
    authorProfile: UserProfile(
      address: '0vefoiwiafjvkbr32r243r5',
      firstName: 'Dora',
      lastName: 'Czovek',
      profilePicture: 'assets/images/junto-mobile__dora.png',
      bio: 'hellooo',
      parent: 'parent-address',
      verified: true,
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
      expressionType: 'photo',
      expressionContent: <String, String>{
        'image': 'assets/images/junto-mobile__photo--one.png',
        'caption': 'Catching some waves in New Polzeath!'
      },
    ),
    authorUsername: Username(
      address: '02efredffdfvdbnrtg',
      username: 'jdlparkin',
    ),
    authorProfile: UserProfile(
      address: '0vefoiwiafjvkbr32r243r5',
      firstName: 'Josh',
      lastName: 'Parkin',
      profilePicture: 'assets/images/junto-mobile__josh.png',
      bio: 'hellooo',
      parent: 'parent-address',
      verified: true,
    ),
    subExpressions: <Expression>[],
    resonations: <dynamic>[],
    timestamp: '18',
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
        'title': 'Junto Presents: Jazz and Draw',
        'location': 'The Assemblage',
        'time': 'Sun, Sep 15, 3:00PM',
        'image': 'assets/images/junto-mobile__event--one.png',
        'description':
            "Join us for a splendiferous afternoon of paint-splattering fun! We'll be syncing our movements to your favorite blues while creating beautiful masterpieces together. All are invited!"
      },
    ),
    authorProfile: UserProfile(
      address: '0vefoiwiafjvkbr32r243r5',
      parent: 'parent-address',
      bio: "I'm Drea.",
      firstName: 'Drea',
      lastName: 'Bennett',
      profilePicture: 'assets/images/junto-mobile__drea.png',
      verified: true,
    ),
    authorUsername: Username(
      address: '02efredffdfvdbnrtg',
      username: 'DMONEY',
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
      expressionType: 'longform',
      expressionContent: <String, String>{
        'title': 'Welcome to Junto!',
        'body':
            "Hey! I'm Nash. Over the past few weeks, I've been working with Eric and the rest of the Junto team to prepare for Junto's upcoming release. I also just finished a project for the government of Trinidad and Tobago (where i'm from) and I'm stoked to say we won first place! Anyway, really looking forward to watching this go live. Can't wait to meet you all!"
      },
    ),
    subExpressions: <Expression>[],
    authorUsername: Username(
      address: '02efredffdfvdbnrtg',
      username: 'nash',
    ),
    authorProfile: UserProfile(
      address: '0vefoiwiafjvkbr32r243r5',
      parent: 'parent-address',
      bio: 'hellooo',
      firstName: 'Nash',
      lastName: 'Ramdial',
      profilePicture: 'assets/images/junto-mobile__nash.png',
      verified: true,
    ),
    resonations: <dynamic>[],
    timestamp: '33',
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
        'image': 'assets/images/junto-mobile__photo--two.png',
        'caption': 'Hi, Yaz here!',
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
    timestamp: '38',
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
        'title': 'The funny story about my name...',
        'body':
            "A question I get all the time is, 'Is that your real name?' Well, I'm glad you asked. You see, it was a hot afternoon in Lexington, Kentucky. Feeling hangry, I swung by the closest Subway shop and..."
      },
    ),
    subExpressions: <Expression>[],
    timestamp: '4',
    authorProfile: UserProfile(
      address: '0vefoiwiafjvkbr32r243r5',
      parent: 'parent-address',
      firstName: 'Tomis',
      lastName: 'Parker',
      profilePicture: 'assets/images/junto-mobile__tomis.png',
      verified: true,
      bio: 'hellooo',
    ),
    authorUsername: Username(
      address: '02efredffdfvdbnrtg',
      username: 'tomis',
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
  Expression(
    expression: ExpressionContent(
      address: '0xfee32zokie8',
      expressionType: 'event',
      expressionContent: <String, String>{
        'title': 'Happiness is Your True Nature',
        'location': 'within',
        'time': 'ANYTIME',
        'image': 'assets/images/junto-mobile__event--two.png',
        'description':
            "Now, you may not be as muscular as this stud. But let me tell you - You. Are. Beautiful. Everything you need is within, so come book an appointmnet with Happy Leif and we're guarantee you some Happy Photos ;)"
      },
    ),
    authorProfile: UserProfile(
      address: '0vefoiwiafjvkbr32r243r5',
      parent: 'parent-address',
      bio: "I'm Leif.",
      firstName: 'Leif',
      lastName: 'Lioness',
      profilePicture: 'assets/images/junto-mobile__leif.png',
      verified: true,
    ),
    authorUsername: Username(
      address: '02efredffdfvdbnrtg',
      username: 'leifthelion',
    ),
    subExpressions: <Expression>[],
    resonations: <dynamic>[],
    timestamp: '59',
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
