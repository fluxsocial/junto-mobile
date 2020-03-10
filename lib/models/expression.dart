import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/utils.dart';

/// Base class for posting an expression to the server
class ExpressionModel {
  ExpressionModel({
    @required this.type,
    @required this.expressionData,
    this.channels: const <String>[],
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

  final String title;
  final String body;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'title': title,
        'body': body,
      };
}

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

  final List<dynamic> background;
  final String body;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'background': background,
        'body': body,
      };
}

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

  String image;
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

class ExpressionResponse {
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

  final String address;
  final String type;
  final dynamic expressionData;
  final DateTime createdAt;
  final int numberResonations;
  final int numberComments;
  final dynamic resonations;
  final dynamic comments;
  final String privacy;
  final List<dynamic> channels;
  final String context;
  final UserProfile creator;

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

class ExpressionQueryParams {
  ExpressionQueryParams({
    @required this.dos,
    @required this.context,
    @required this.channels,
    @required this.contextType,
    @required this.paginationPos,
  });

  final int dos;
  final int context;
  final List<String> channels;
  final ExpressionContextType contextType;
  final int paginationPos;
}

enum ExpressionContextType { dos, perspective, random, collective }

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
