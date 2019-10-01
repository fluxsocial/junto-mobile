import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

/// Expressions are at the center of Junto. Users can choose form Longform,
/// shortform and media.
class Expression {
  Expression({
    this.expression,
    this.subExpressions,
    this.authorUsername,
    this.authorProfile,
    this.resonations,
    this.timestamp,
    this.channels,
  });

  /// Creates an [Expression] from the given map
  factory Expression.fromMap(Map<String, dynamic> json) {
    return Expression(
      expression: ExpressionContent.fromMap(
        json['expression'],
      ),
      subExpressions: List<Expression>.from(
        json['sub_expressions'].map(
          (Map<String, dynamic> expression) => Expression.fromMap(expression),
        ),
      ),
      authorUsername: Username.fromMap(
        json['author_username'],
      ),
      authorProfile: UserProfile.fromMap(
        json['author_profile'],
      ),
      resonations: List<dynamic>.from(
        json['resonations'].map((dynamic resonations) => resonations),
      ),
      timestamp: json['timestamp'],
      channels: List<Channel>.from(
        json['channels'].map(
          (dynamic channel) => Channel.fromMap(channel),
        ),
      ),
    );
  }

  final ExpressionContent expression;

  /// List of expressions associated with the given `Expression`
  final List<Expression> subExpressions;

  /// This field contains the author's address and entry (username)
  final Username authorUsername;

  /// Contains the address and profile information associated with the author.
  final UserProfile authorProfile;

  //TODO(Nash):  Speak to Eric regarding the content of resonations
  final List<dynamic> resonations;

  /// String containing the date
  final String timestamp;

  /// The channel where the expression was posted
  final List<Channel> channels;

  /// Converts the given expression to Map
  Map<String, dynamic> toMap() => <String, dynamic>{
        'expression': expression.toMap(),
        'sub_expressions': List<dynamic>.from(
          subExpressions.map(
            (Expression subExpression) => subExpression.toMap(),
          ),
        ),
        'author_username': authorUsername.toMap(),
        'author_profile': authorProfile.toMap(),
        'resonations': List<dynamic>.from(
          resonations.map((dynamic resonations) => resonations),
        ),
        'timestamp': timestamp,
        'channels': List<dynamic>.from(
          channels.map(
            (Channel channel) => channel.toMap(),
          ),
        ),
      };
}

class Channel {
  Channel({
    this.address,
    this.value,
    this.attributeType,
  });

  factory Channel.fromMap(Map<String, dynamic> json) => Channel(
        address: json['address'],
        attributeType: json['entry']['attribute_type'],
        value: json['entry']['value'],
      );

  /// Location
  final String address;

  /// Channel where the `Expression` was posted
  final String value;

  final String attributeType;

  /// Converts the object to a map
  Map<String, dynamic> toMap() => <String, dynamic>{
        'address': address,
        'entry': <String, String>{
          'value': value,
          'attribute_type': attributeType,
        },
      };
}

/// Contains the type of expression along with the content of the expression.
/// Fields include [title] and [body].
class ExpressionContent {
  ExpressionContent({
    this.address,
    this.expressionContent,
    this.expressionType,
  });

  factory ExpressionContent.fromMap(Map<String, dynamic> json) {
    return ExpressionContent(
      address: json['address'],
      expressionType: json['entry']['expression_type'],
      expressionContent: json['entry']['expression'],
    );
  }

  /// Location
  String address;

  /// The type of [Expression]. Longform or shortform
  final String expressionType;

  /// Contains the content of the expression. Varies depending on
  /// [expressionType]
  final Map<String, dynamic> expressionContent;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'entry': <String, dynamic>{
        'expression_type': expressionType,
        'expression': expressionContent,
      },
    };
  }
}

enum ExpressionType {
  LongForm,
  ShortForm,
  PhotoForm,
  EventForm,
  BulletForm,
}

/// Base class for posting an expression to the server
class CentralizedExpression {
  CentralizedExpression({
    @required this.type,
    @required this.expressionData,
    @required this.context,
  });

  factory CentralizedExpression.fromMap(Map<String, dynamic> map) {
    return CentralizedExpression(
      type: map['type'] as String,
      expressionData: map['expression_data'] as Map<String, dynamic>,
      context: map['context'] as Map<String, dynamic>,
    );
  }

  final String type;
  final Map<String, dynamic> expressionData;
  final Map<String, dynamic> context;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'expression_data': expressionData,
      'context': context,
    };
  }
}

class CentralizedLongFormExpression {
  CentralizedLongFormExpression({
    this.title,
    this.body,
  });

  factory CentralizedLongFormExpression.fromMap(Map<String, dynamic> json) {
    return CentralizedLongFormExpression(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  final String title;
  final String body;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'title': title,
        'body': body,
      };
}

class CentralizedShortFormExpression {
  CentralizedShortFormExpression({
    @required this.background,
    @required this.body,
  });

  factory CentralizedShortFormExpression.fromMap(Map<String, dynamic> json) {
    return CentralizedShortFormExpression(
      background: json['background'],
      body: json['body'],
    );
  }

  final String background;
  final String body;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'background': background,
        'body': body,
      };
}

class CentralizedPhotoFormExpression {
  CentralizedPhotoFormExpression({
    this.image,
    this.caption,
  });

  factory CentralizedPhotoFormExpression.fromMap(Map<String, dynamic> json) {
    return CentralizedPhotoFormExpression(
      image: json['image'],
      caption: json['caption'],
    );
  }

  String image;
  String caption;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'image': image,
        'caption': caption,
      };
}

class CentralizedEventFormExpression {
  CentralizedEventFormExpression({
    this.title,
    this.description,
    this.photo,
    this.location,
    this.startTime,
    this.endTime,
  });

  factory CentralizedEventFormExpression.fromMap(Map<String, dynamic> json) {
    return CentralizedEventFormExpression(
      title: json['title'],
      description: json['description'],
      photo: json['photo'],
      location: json['location'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }

  final String title;
  final String description;
  final String photo;
  final String location;
  final String startTime;
  final String endTime;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'title': title,
        'description': description,
        'photo': photo,
        'location': location,
        'start_time': startTime,
        'end_time': endTime,
      };
}

class CentralizedBulletFormExpression {
  CentralizedBulletFormExpression({
    this.title,
    this.bullets,
  });

  factory CentralizedBulletFormExpression.fromMap(Map<String, dynamic> json) {
    return CentralizedBulletFormExpression(
      title: json['title'],
      bullets: List<String>.from(
        json['bullets'].map(
          (String _bullet) {
            return _bullet;
          },
        ),
      ),
    );
  }

  final String title;
  final List<String> bullets;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'bullet': List<String>.from(
        bullets.map((String _bullet) => _bullet),
      ),
    };
  }
}

class CentralizedExpressionResponse {
  CentralizedExpressionResponse(
      {this.address,
      this.type,
      this.expressionData,
      this.createdAt,
      this.numberComments,
      this.numberResonations,
      this.creator,
      this.context,
      this.privacy,
      this.comments = const <Comment>[],
      this.resonations = const <UserProfile>[]});

  factory CentralizedExpressionResponse.withCommentsAndResonations(Map<String, dynamic> json) {
    return CentralizedExpressionResponse(
      address: json['address'],
      type: json['type'],
      expressionData: generateExpressionData(
        json['type'],
        json['expression_data'],
      ),
      createdAt: DateTime.parse(
        json['created_at'],
      ),
      numberComments: json['comments'].length,
      numberResonations: json['resonations'].length,
      creator: UserProfile.fromMap(
        json['creator'],
      ),
      privacy: json['privacy'] ?? '',
      context: json['context'] ?? '',
      comments: List<Comment>.from(
        json['comments'].map(
          (Map<String, dynamic> comment) => UserProfile.fromMap(comment),
        ),
      ),
      resonations: List<UserProfile>.from(
        json['resonations'].map(
          (Map<String, dynamic> profile) => UserProfile.fromMap(profile),
        ),
      ),
    );
  }

  factory CentralizedExpressionResponse.fromMap(Map<String, dynamic> json) {
    return CentralizedExpressionResponse(
      address: json['address'],
      type: json['type'],
      expressionData: generateExpressionData(
        json['type'],
        json['expression_data'],
      ),
      createdAt: DateTime.parse(
        json['created_at'],
      ),
      numberComments: json['comments'] ?? 0,
      numberResonations: json['resonations'] ?? 0,
      creator: UserProfile.fromMap(
        json['creator'],
      ),
      privacy: json['privacy'] ?? '',
      context: json['context'] ?? '',
    );
  }

  final String address;
  final String type;
  final dynamic expressionData;
  final DateTime createdAt;
  final int numberComments;
  final int numberResonations;
  final List<Comment> comments;
  final List<UserProfile> resonations;
  final String privacy;
  final String context;
  final UserProfile creator;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'type': type,
      'expression_data': expressionData.toMap(),
      'created_at': createdAt.toIso8601String(),
      'comments': numberComments,
      'resonations': numberResonations,
      'creator': creator.toMap(),
      'privacy': privacy ?? '',
      'context': context ?? '',
    };
  }

  static dynamic generateExpressionData(String type, Map<String, dynamic> json) {
    if (type == 'LongForm') {
      return CentralizedLongFormExpression.fromMap(json);
    }
    if (type == 'ShortForm') {
      return CentralizedShortFormExpression.fromMap(json);
    }
    if (type == 'PhotoForm') {
      return CentralizedPhotoFormExpression.fromMap(json);
    }
    if (type == 'EventForm') {
      return CentralizedEventFormExpression.fromMap(json);
    }
    if (type == 'BulletForm') {
      return CentralizedBulletFormExpression.fromMap(json);
    }
  }
}

class Comment {
  Comment({
    this.address,
    this.type,
    this.expressionData,
    this.creator,
    this.comments,
    this.resonations,
    this.createdAt,
    this.privacy,
    this.context,
  });

  factory Comment.fromMap(Map<String, dynamic> json) {
    return Comment(
      address: json['address'],
      type: json['type'],
      expressionData: CentralizedExpressionResponse.generateExpressionData(
        json['type'],
        json['expression_data'],
      ),
      creator: UserProfile.fromMap(json['creator']),
      comments: json['comments'],
      resonations: json['resonations'],
      createdAt: DateTime.parse(json['created_at']),
      privacy: json['privacy'],
      context: json['context'],
    );
  }

  final String address;
  final String type;
  final dynamic expressionData;
  final UserProfile creator;
  final int comments;
  final int resonations;
  final DateTime createdAt;
  final String privacy;
  final String context;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'address': address,
        'type': type,
        'expression_data': expressionData.toMap(),
        'creator': creator.toMap(),
        'comments': comments,
        'resonations': resonations,
        'created_at': createdAt.toIso8601String(),
        'privacy': privacy,
        'context': context,
      };
}
