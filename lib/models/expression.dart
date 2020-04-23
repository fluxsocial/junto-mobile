import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/utils.dart';

part 'expression.g.dart';

/// Base class for posting an expression to the server

class ExpressionModel {
  ExpressionModel({
    @required this.type,
    @required this.expressionData,
    this.channels = const <String>[],
    this.context,
  });

  factory ExpressionModel.fromMap(Map<String, dynamic> map) {
    return ExpressionModel(
      type: map['type'] as String,
      channels: List<String>.from(map['channels']),
      expressionData: map['expression_data'] as Map<String, dynamic>,
      context: map['context'] as Map<String, dynamic>,
    );
  }

  /// Type of expression being created. Server currently supports  LongForm,
  /// ShortForm, PhotoForm, EventForm.
  final String type;

  /// Map representation of the expression. Values are dependant on [type].
  /// Can be serialized to an object:
  /// * [LongFormExpression],
  /// * [ShortFormExpression]
  /// * [PhotoFormExpression]
  /// * [EventFormExpression]
  /// * [AudioFormExpression]

  final Map<String, dynamic> expressionData;

  /// Context for the given expression. Value is dependant on [ExpressionContext].
  /// See docs for details: https://github.com/juntofoundation/Junto-Alpha-API/blob/master/docs/expression.md

  final dynamic context;

  /// list of channel UUIDs the expression will be shared to.
  final List<String> channels;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'expression_data': expressionData,
      'context': context,
      'channels': channels,
    };
  }

  ExpressionModel copyWith({
    String type,
    Map<String, dynamic> expressionData,
    dynamic context,
    List<String> channels = const <String>[],
  }) {
    return ExpressionModel(
      type: type ?? this.type,
      expressionData: expressionData ?? this.expressionData,
      context: context ?? this.context,
      channels: channels ?? this.channels,
    );
  }
}

@HiveType(typeId: 5)
class AudioFormExpression {
  AudioFormExpression({
    this.title,
    this.photo,
    this.audio,
    this.gradient,
  });

  // TODO: we're waiting for the model from API so right now these properties are "dummy"
  // probably it will be similar to photo expression

  factory AudioFormExpression.fromMap(Map<String, dynamic> json) {
    return AudioFormExpression(
      title: json['title'] ?? '',
      photo: json['photo'] ?? '',
      audio: json['audio'] ?? '',
      gradient: json['gradient']?.cast<String>() ?? [],
    );
  }

  @HiveField(0)
  final String title;
  @HiveField(1)
  final String photo;
  @HiveField(2)
  final String audio;
  @HiveField(3)
  final List<String> gradient;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'title': title ?? '',
        'photo': photo ?? '',
        'audio': audio ?? '',
        'gradient': gradient ?? [],
      };
}

@HiveType(typeId: 4)
class LongFormExpression {
  LongFormExpression({
    this.title,
    this.body,
  });

  factory LongFormExpression.fromMap(Map<String, dynamic> json) {
    return LongFormExpression(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  @HiveField(0)
  final String title;
  @HiveField(1)
  final String body;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'title': title,
        'body': body,
      };
}

@HiveType(typeId: 3)
class ShortFormExpression {
  ShortFormExpression({
    @required this.background,
    @required this.body,
  });

  factory ShortFormExpression.fromMap(Map<String, dynamic> json) {
    return ShortFormExpression(
      background: json['background'],
      body: json['body'],
    );
  }

  @HiveField(0)
  final List<dynamic> background;
  @HiveField(1)
  final String body;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'background': background,
        'body': body,
      };
}

@HiveType(typeId: 2)
class PhotoFormExpression {
  PhotoFormExpression({
    this.image,
    this.caption,
  });

  factory PhotoFormExpression.fromMap(Map<String, dynamic> json) {
    return PhotoFormExpression(
      image: json['image'],
      caption: json['caption'],
    );
  }

  @HiveField(0)
  String image;
  @HiveField(1)
  String caption;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'image': image,
        'caption': caption,
      };
}

class EventFormExpression {
  EventFormExpression(
      {this.title,
      this.description,
      this.photo,
      this.location,
      this.startTime,
      this.endTime,
      this.facilitators,
      this.members});

  factory EventFormExpression.fromMap(Map<String, dynamic> json) {
    return EventFormExpression(
        title: json['title'],
        description: json['description'],
        photo: json['photo'],
        location: json['location'],
        startTime: json['start_time'],
        endTime: json['end_time'],
        facilitators: json['facilitators'],
        members: json['members']);
  }

  final String title;
  final String description;
  final String photo;
  final String location;
  final String startTime;
  final String endTime;
  final List<String> facilitators;
  final List<String> members;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'title': title,
        'description': description,
        'photo': photo,
        'location': location,
        'start_time': startTime,
        'end_time': endTime,
        'facilitators': facilitators,
        'members': members
      };
}

@HiveType(typeId: 0)
class ExpressionResponse extends HiveObject {
  ExpressionResponse({
    this.address,
    this.type,
    this.expressionData,
    this.createdAt,
    this.numberResonations,
    this.creator,
    this.context,
    this.privacy,
    this.channels,
    this.numberComments = 0,
    this.comments,
    this.resonations,
  });

  factory ExpressionResponse.withCommentsAndResonations(
      Map<String, dynamic> json) {
    return ExpressionResponse(
      address: json['address'],
      type: json['type'],
      expressionData: generateExpressionData(
        json['type'],
        json['expression_data'],
      ),
      createdAt: RFC3339.parseRfc3339(
        json['created_at'],
      ),
      numberResonations: json['resonations'] as int,
      creator: UserProfile.fromMap(
        json['creator'],
      ),
      privacy: json['privacy'] ?? '',
      channels: json['channels'],
      context: json['context'] ?? '',
      numberComments: json['comments'],
    );
  }

  factory ExpressionResponse.fromMap(Map<String, dynamic> json) {
    return ExpressionResponse(
      address: json['address'],
      type: json['type'],
      expressionData: generateExpressionData(
        json['type'],
        json['expression_data'],
      ),
      createdAt: RFC3339.parseRfc3339(
        json['created_at'],
      ),
      creator: UserProfile.fromMap(
        json['creator'],
      ),
      privacy: json['privacy'] ?? '',
      channels: json['channels'],
      context: json['context'] ?? '',
      comments: json['comments'],
      resonations: json['resonations'],
    );

    // comments: json['comments'].runtimeType == int
    //     ? json['comments']
    //     : List<Comment>.from(
    //         json['comments']['results'].map(
    //           (dynamic comment) => Comment.fromMap(comment),
    //         ),
    //       ),
    // resonations: json['resonations'].runtimeType == int
    //     ? json['resonations']
    //     : List<UserProfile>.from(
    //         json['resonations']['results'].map(
    //           (dynamic res) => UserProfile.fromMap(res),
    //         ),
    //       ),
  }

  @HiveField(0)
  final String address;
  @HiveField(1)
  final String type;
  @HiveField(2)
  final dynamic expressionData;
  @HiveField(3)
  final int numberResonations;
  @HiveField(4)
  final int numberComments;
  @HiveField(5)
  final dynamic resonations;
  @HiveField(6)
  final dynamic comments;
  @HiveField(7)
  final String privacy;
  @HiveField(8)
  final List<dynamic> channels;
  @HiveField(9)
  final String context;
  @HiveField(10)
  final UserProfile creator;
  @HiveField(11)
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'type': type,
      'expression_data': expressionData.toJson(),
      'created_at': createdAt.toIso8601String(),
      'resonations': numberResonations,
      'creator': creator.toMap(),
      'privacy': privacy ?? '',
      'channels': channels,
      'context': context ?? '',
    };
  }

  @override
  String toString() {
    return '$type : ${creator.name} : $context';
  }

  static dynamic generateExpressionData(
      String type, Map<String, dynamic> json) {
    if (type == 'LongForm') {
      return LongFormExpression.fromMap(json);
    }
    if (type == 'ShortForm') {
      return ShortFormExpression.fromMap(json);
    }
    if (type == 'PhotoForm') {
      return PhotoFormExpression.fromMap(json);
    }
    if (type == 'EventForm') {
      return EventFormExpression.fromMap(json);
    }
    if (type == 'AudioForm') {
      return AudioFormExpression.fromMap(json);
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
      expressionData: ExpressionResponse.generateExpressionData(
        json['type'],
        json['expression_data'],
      ),
      creator: UserProfile.fromMap(json['creator']),
      comments: json['comments'],
      resonations: json['resonations'],
      createdAt: RFC3339.parseRfc3339(json['created_at']),
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
        'expression_data': expressionData.toJson(),
        'creator': creator.toMap(),
        'comments': comments,
        'resonations': resonations,
        'created_at': createdAt.toIso8601String(),
        'privacy': privacy,
        'context': context,
      };
}

class GroupExpressionQueryParams {
  GroupExpressionQueryParams({
    this.resonations,
    this.directExpressions,
    this.creatorExpressions,
    this.resonationsPaginationPosition,
    this.directExpressionPaginationPosition,
    this.creatorExpressionsPaginationPosition,
  });

  final bool resonations;
  final bool directExpressions;
  final bool creatorExpressions;
  final int resonationsPaginationPosition;
  final int directExpressionPaginationPosition;
  final int creatorExpressionsPaginationPosition;
}

/// Generic class encapsulating a query results.
class QueryResults<T> {
  QueryResults({
    @required this.results,
    @required this.lastTimestamp,
  });

  final List<T> results;
  final String lastTimestamp;
}

class Channel with RFC3339 {
  const Channel({
    @required this.name,
    this.createdAt,
  });

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      name: map['name'] as String,
      createdAt: RFC3339.parseRfc3339(map['created_at']),
    );
  }

  final String name;
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return <String, String>{
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() => name;
}
