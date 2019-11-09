import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/resonation_model.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

class MockExpressionService implements ExpressionService {
  static UserProfile kUserProfile = UserProfile(
    address: '123e4567-e89b-23s3-a256-426655440000',
    bio: 'Hi there, this is a mock user profile',
    firstName: 'Testy',
    lastName: 'Testing',
    parent: null,
    profilePicture: 'assets/images/junto-mobile__junto.png',
    username: 'mcTesty',
    verified: false,
  );

  static CentralizedExpressionResponse kExpressionResponse =
      CentralizedExpressionResponse(
    address: '123e4567-e89b-12d3-a456-426655440000',
    comments: <Comment>[],
    context: 'collective',
    createdAt: DateTime.now(),
    creator: kUserProfile,
    expressionData:
        CentralizedLongFormExpression(title: 'Mocking', body: 'Expressions'),
    numberComments: 0,
    numberResonations: 0,
    privacy: 'Public',
    resonations: <UserProfile>[],
    type: 'LongForm',
  );

  static List<CentralizedExpressionResponse> kSampleExpressions =
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
        body:
            ' Have you heard of Paradym sound healing meditation? Join us for '
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
        // title: 'Welcome to Junto!',
        title: '',
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

  static Comment kComment = Comment(
    address: '123e4567-e89b-23s3-a256-426655440000',
    comments: 0,
    context: 'collective',
    createdAt: DateTime.now(),
    creator: kUserProfile,
    expressionData: CentralizedLongFormExpression(
      title: 'Mocking',
      body: 'Expressions',
    ),
    privacy: 'Public',
    resonations: 0,
    type: 'LongForm',
  );

  static Resonation kResonation = Resonation(
    expressionAddress: '123e4567-e89b-12d3-a456-426655440000',
    groupAddress: null,
    linkType: 'Resonation',
  );

  @override
  List<CentralizedExpressionResponse> get collectiveExpressions =>
      kSampleExpressions;

  @override
  Future<CentralizedExpressionResponse> createExpression(
      CentralizedExpression expression) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return kExpressionResponse;
  }

  @override
  Future<CentralizedExpressionResponse> getExpression(
    String expressionAddress,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 2000));
    return kExpressionResponse;
  }

  @override
  Future<List<Comment>> getExpressionsComments(String expressionAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 2000));
    return List<Comment>.generate(50, (int index) => kComment);
  }

  @override
  Future<List<UserProfile>> getExpressionsResonation(
      String expressionAddress) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return List<UserProfile>.generate(12, (int index) => kUserProfile);
  }

  @override
  Future<CentralizedExpressionResponse> postCommentExpression(
    String parentAddress,
    String type,
    Map<String, dynamic> data,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return kExpressionResponse;
  }

  @override
  Future<Resonation> postResonation(String expressionAddress) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return kResonation;
  }

  @override
  Future<List<CentralizedExpressionResponse>> queryExpression(
      ExpressionQueryParams params) async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return List<CentralizedExpressionResponse>.generate(
        12, (int index) => kExpressionResponse);
  }
}
