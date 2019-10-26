import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:meta/meta.dart';

/// Concrete implementation of [ExpressionService]
@immutable
class ExpressionServiceCentralized implements ExpressionService {
  const ExpressionServiceCentralized(this.client);

  final JuntoHttp client;

  @override
  List<CentralizedExpressionResponse> get collectiveExpressions =>
      sampleExpressions;

  @override
  Future<CentralizedExpressionResponse> createExpression(
      CentralizedExpression expression) async {
    final Map<String, dynamic> _postBody = expression.toMap();
    final http.Response _serverResponse =
        await client.postWithoutEncoding('/expressions', body: _postBody);
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
    final http.Response _serverResponse = await client.post(
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
    final http.Response _serverResponse = await client.post(
      '/expressions/$expressionAddress/resonations',
    );
    return Resonation.fromMap(JuntoHttp.handleResponse(_serverResponse));
  }

  @override
  Future<CentralizedExpressionResponse> getExpression(
    String expressionAddress,
  ) async {
    final http.Response _response =
        await client.get('/expressions/$expressionAddress');
    final Map<String, dynamic> _decodedResponse =
        JuntoHttp.handleResponse(_response);
    return CentralizedExpressionResponse.withCommentsAndResonations(
        _decodedResponse);
  }

  @override
  Future<List<Comment>> getExpressionsComments(String expressionAddress) async {
    final http.Response response =
        await client.get('/expressions/$expressionAddress/comments');
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
        await client.get('/expressions/$expressionAddress/resonations');
    final List<dynamic> _listData = json.decode(response.body);
    final List<UserProfile> _results = _listData
        .map((dynamic data) => UserProfile.fromMap(data))
        .toList(growable: false);
    return _results;
  }
}

List<CentralizedExpressionResponse> sampleExpressions =
    <CentralizedExpressionResponse>[
  CentralizedExpressionResponse(
    address: '0xfee32zokie8',
    type: 'LongForm',
    comments: <Comment>[],
    context: '',
    createdAt: DateTime.now(),
    creator: UserProfile(
      bio: 'hellooo',
      firstName: 'Eric',
      lastName: 'Yang',
      profilePicture: 'assets/images/junto-mobile__eric.png',
      username: 'sunyata',
      verified: true,
    ),
    expressionData: CentralizedLongFormExpression(
      title: 'Dynamic form is in motion!',
      body: "Hey! Eric here. We're currently working with a London-based dev "
          "agency called DevAngels to build out our dynamic, rich text editor. Soon, you'll be able to create short or longform expressions that contain text, links, images complemented with features such as bullet points, horiozntal lines, bold and italic font, and much more. This should be done in the next 1 or 2 weeks so stay tuned!",
    ),
  ),
  CentralizedExpressionResponse(
    address: '0xfee32zokie8',
    type: 'ShortForm',
    comments: <Comment>[],
    context: '',
    createdAt: DateTime.now(),
    creator: UserProfile(
      firstName: 'Dora',
      lastName: 'Czovek',
      profilePicture: 'assets/images/junto-mobile__dora.png',
      bio: 'hellooo',
      username: 'wingedmessenger',
      parent: 'parent-address',
      verified: true,
    ),
    expressionData: CentralizedShortFormExpression(
      background: 'four',
      body: ' Have you heard of Paradym sound healing meditation? Join us for '
          'a transformational session this Friday!',
    ),
  ),
  CentralizedExpressionResponse(
    address: '0xfee32zokie8',
    type: 'PhotoForm',
    comments: <Comment>[],
    context: '',
    createdAt: DateTime.now(),
    creator: UserProfile(
      firstName: 'Josh',
      lastName: 'Parkin',
      profilePicture: 'assets/images/junto-mobile__josh.png',
      bio: 'hellooo',
      parent: 'parent-address',
      verified: true,
      username: 'jdlparkin',
    ),
    expressionData: CentralizedPhotoFormExpression(
      image: 'assets/images/junto-mobile__photo--one.png',
      caption: 'Catching some waves in New Polzeath!',
    ),
  ),
  CentralizedExpressionResponse(
    address: '0xfee32zokie8',
    type: 'EventForm',
    comments: <Comment>[],
    context: '',
    createdAt: DateTime.now(),
    creator: UserProfile(
      parent: 'parent-address',
      bio: "I'm Drea.",
      firstName: 'Drea',
      lastName: 'Bennett',
      profilePicture: 'assets/images/junto-mobile__drea.png',
      verified: true,
      username: 'DMONEY',
    ),
    expressionData: CentralizedEventFormExpression(
        title: 'Junto Presents: Jazz and Draw',
        location: 'The Assemblage',
        startTime: 'Sun, Sep 15, 3:00PM',
        photo: 'assets/images/junto-mobile__event--one.png',
        description:
            "Join us for a splendiferous afternoon of paint-splattering fun! We'll be syncing our movements to your favorite blues while creating beautiful masterpieces together. All are invited!"),
  ),
  CentralizedExpressionResponse(
    address: '0xfee32zokie8',
    type: 'LongForm',
    comments: <Comment>[],
    context: '',
    createdAt: DateTime.now(),
    creator: UserProfile(
      address: '0vefoiwiafjvkbr32r243r5',
      parent: 'parent-address',
      bio: 'hellooo',
      firstName: 'Nash',
      lastName: 'Ramdial',
      profilePicture: 'assets/images/junto-mobile__nash.png',
      verified: true,
      username: 'Nash',
    ),
    expressionData: CentralizedLongFormExpression(
      title: 'Welcome to Junto!',
      body: "Hey! I'm Nash. Over the past few weeks, I've been working with"
          " Eric and the rest of the Junto team to prepare for Junto's "
          'upcoming release. I also just finished a project for the '
          "government of Trinidad and Tobago (where i'm from) and I'm stoked to say we won first place! Anyway, really looking forward to watching this g,o live. Can't wait to meet you all!",
    ),
  ),
  CentralizedExpressionResponse(
    address: '0xfee32zokie8',
    type: 'PhotoForm',
    comments: <Comment>[],
    context: '',
    createdAt: DateTime.now(),
    creator: UserProfile(
      address: '0vefoiwiafjvkbr32r243r5',
      firstName: 'Yaz',
      lastName: 'Owainati',
      profilePicture: 'assets/images/junto-mobile__yaz.png',
      bio: 'hellooo',
      parent: 'parent-address',
      verified: true,
      username: 'yaz',
    ),
    expressionData: CentralizedPhotoFormExpression(
      image: 'assets/images/junto-mobile__photo--two.png',
      caption: 'Hi, Yaz here!',
    ),
  ),
  CentralizedExpressionResponse(
    address: '0xfee32zokie8',
    type: 'LongForm',
    comments: <Comment>[],
    context: '',
    createdAt: DateTime.now(),
    creator: UserProfile(
      address: '0vefoiwiafjvkbr32r243r5',
      parent: 'parent-address',
      firstName: 'Tomis',
      lastName: 'Parker',
      profilePicture: 'assets/images/junto-mobile__tomis.png',
      verified: true,
      bio: 'hellooo',
      username: 'tomis',
    ),
    expressionData: CentralizedLongFormExpression(
      title: 'The funny story about my name...',
      body: "A question I get all the time is, 'Is that your real name?' "
          "Well, I'm glad you asked. You see, it was a hot afternoon in Lexington, Kentucky. Feeling hangry, I swung by the closest Subway shop and...",
    ),
  ),
  CentralizedExpressionResponse(
    address: '0xfee32zokie8',
    type: 'EventForm',
    comments: <Comment>[],
    context: '',
    createdAt: DateTime.now(),
    creator: UserProfile(
      address: '0vefoiwiafjvkbr32r243r5',
      parent: 'parent-address',
      bio: "I'm Leif.",
      firstName: 'Leif',
      lastName: 'Lioness',
      profilePicture: 'assets/images/junto-mobile__leif.png',
      verified: true,
      username: 'leifthelion',
    ),
    expressionData: CentralizedEventFormExpression(
        title: 'Happiness is Your True Nature',
        location: 'within',
        startTime: 'ANYTIME',
        photo: 'assets/images/junto-mobile__event--two.png',
        description:
            "Now, you may not be as muscular as this stud. But let me tell you - You. Are. Beautiful. Everything you need is within, so come book an appointmnet with Happy Leif and we're guarantee you some Happy Photos ;)"),
  ),
];
