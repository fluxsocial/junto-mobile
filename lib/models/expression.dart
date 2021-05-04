import 'package:embedly_preview/embedly_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/utils.dart';

part 'expression.g.dart';

/// Base class for posting an expression to the server

class ExpressionModel {
  ExpressionModel({
    @required this.type,
    @required this.expressionData,
    this.channels = const <String>[],
    this.mentions,
    this.context,
  });

  factory ExpressionModel.fromJson(Map<String, dynamic> map) {
    return ExpressionModel(
        type: map['type'] as String,
        channels: List<String>.from(map['channels']),
        expressionData: map['expression_data'] as Map<String, dynamic>,
        context: map['context'] as Map<String, dynamic>,
        mentions: List<String>.from(map['mentions']));
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

  // List of mentions [uuids]
  final List<String> mentions;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type,
      'expression_data': expressionData,
      'context': context,
      'channels': channels,
      'mentions': mentions,
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
      mentions: mentions ?? this.mentions,
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
    this.caption,
    this.thumbnail300,
    this.thumbnail600,
  });

  factory AudioFormExpression.fromJson(Map<String, dynamic> json) {
    return AudioFormExpression(
      title: json['title'] ?? '',
      photo: json['photo'] ?? '',
      audio: json['audio'] ?? '',
      gradient: json['gradient']?.cast<String>() ?? [],
      caption: json['caption'] ?? '',
      thumbnail300: json['thumbnail300'],
      thumbnail600: json['thumbnail600'],
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
  @HiveField(4)
  final String caption;
  @HiveField(5)
  String thumbnail300;
  @HiveField(6)
  String thumbnail600;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title ?? '',
        'photo': photo ?? '',
        'audio': audio ?? '',
        'gradient': gradient ?? [],
        'caption': caption ?? '',
        'thumbnail300': thumbnail300 ?? '',
        'thumbnail600': thumbnail600 ?? '',
      };
}

@HiveType(typeId: 4)
class LongFormExpression {
  LongFormExpression({
    this.title,
    this.body,
  });

  factory LongFormExpression.fromJson(Map<String, dynamic> json) {
    return LongFormExpression(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  @HiveField(0)
  final String title;
  @HiveField(1)
  final String body;

  Map<String, dynamic> toJson() => <String, dynamic>{
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

  factory ShortFormExpression.fromJson(Map<String, dynamic> json) {
    return ShortFormExpression(
      background: json['background'],
      body: json['body'],
    );
  }

  @HiveField(0)
  final List<dynamic> background;
  @HiveField(1)
  final String body;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'background': background,
        'body': body,
      };
}

@HiveType(typeId: 8)
class LinkFormExpression {
  LinkFormExpression({
    @required this.title,
    @required this.caption,
    @required this.url,
    @required this.data,
  });

  factory LinkFormExpression.fromJson(Map<String, dynamic> json) {
    return LinkFormExpression(
      title: json['title'],
      caption: json['caption'],
      url: json['url'],
      data: json['data'] != null ? OEmbedResponse.fromMap(json['data']) : null,
    );
  }

  @HiveField(0)
  final String title;
  @HiveField(1)
  final String caption;
  @HiveField(2)
  final String url;
  final OEmbedResponse data;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'caption': caption,
        'url': url,
      };
}

@HiveType(typeId: 2)
class PhotoFormExpression {
  PhotoFormExpression({
    this.image,
    this.caption,
    this.thumbnail300,
    this.thumbnail600,
  });

  factory PhotoFormExpression.fromJson(Map<String, dynamic> json) {
    return PhotoFormExpression(
      image: json['image'],
      caption: json['caption'],
      thumbnail300: json['thumbnail300'],
      thumbnail600: json['thumbnail600'],
    );
  }

  @HiveField(0)
  String image;
  @HiveField(1)
  String caption;
  @HiveField(2)
  String thumbnail300;
  @HiveField(3)
  String thumbnail600;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'image': image,
        'caption': caption,
        'thumbnail300': thumbnail300,
        'thumbnail600': thumbnail600,
      };
}

@HiveType(typeId: 9)
class EventFormExpression extends HiveObject {
  EventFormExpression({
    this.title,
    this.description,
    this.photo,
    this.location,
    this.startTime,
    this.endTime,
    this.facilitators,
    this.members,
    this.thumbnail300,
    this.thumbnail600,
  });

  factory EventFormExpression.fromJson(Map<String, dynamic> json) {
    return EventFormExpression(
      title: json['title'],
      description: json['description'],
      photo: json['photo'],
      location: json['location'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      facilitators: json['facilitators'],
      members: json['members'],
      thumbnail300: json['thumbnail300'],
      thumbnail600: json['thumbnail600'],
    );
  }

  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final String photo;
  @HiveField(3)
  final String location;
  @HiveField(4)
  final String startTime;
  @HiveField(5)
  final String endTime;
  @HiveField(6)
  final List<String> facilitators;
  @HiveField(7)
  final List<String> members;
  @HiveField(8)
  final String thumbnail300;
  @HiveField(9)
  final String thumbnail600;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'description': description,
        'photo': photo,
        'location': location,
        'start_time': startTime,
        'end_time': endTime,
        'facilitators': facilitators,
        'members': members,
        'thumbnail300': thumbnail300,
        'thumbnail600': thumbnail600,
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
    this.commentThread,
  });

  factory ExpressionResponse.withCommentsAndResonations(
      Map<String, dynamic> json) {
    List<dynamic> thread;

    thread = json['comment_thread'] != null
        ? json['comment_thread']['results'] != null
            ? json['comment_thread']['results']
            : []
        : [];

    final compiledThread = thread
        .map((e) => ExpressionResponse.withCommentsAndResonations(
            e as Map<String, dynamic>))
        .toList();

    final response = ExpressionResponse(
      address: json['address'],
      type: json['type'],
      expressionData: generateExpressionData(
        json['type'],
        json['expression_data'],
      ),
      commentThread: compiledThread,
      createdAt: RFC3339.parseRfc3339(
        json['created_at'],
      ),
      resonations: json['resonations'],
      creator: UserProfile.fromJson(
        json['creator'],
      ),
      privacy: json['privacy'] ?? '',
      channels: json['channels'],
      context: json['context'] ?? '',
      comments: json['comments'],
    );

    return response;
  }

  factory ExpressionResponse.fromJson(Map<String, dynamic> json) {
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
      creator: UserProfile.fromJson(
        json['creator'],
      ),
      privacy: json['privacy'] ?? '',
      channels: json['channels'],
      context: json['context'] ?? '',
      comments: json['comments'],
      resonations: json['resonations'],
    );
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
  @HiveField(12)
  final List<ExpressionResponse> commentThread;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'address': address,
      'type': type,
      'expression_data': expressionData.toJson(),
      'created_at': createdAt.toIso8601String(),
      'resonations': numberResonations,
      'creator': creator.toJson(),
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
      return LongFormExpression.fromJson(json);
    }
    if (type == 'ShortForm') {
      return ShortFormExpression.fromJson(json);
    }
    if (type == 'PhotoForm') {
      return PhotoFormExpression.fromJson(json);
    }
    if (type == 'EventForm') {
      return EventFormExpression.fromJson(json);
    }
    if (type == 'AudioForm') {
      return AudioFormExpression.fromJson(json);
    }
    if (type == 'LinkForm') {
      return LinkFormExpression.fromJson(json);
    }
  }
}

extension ExpressionResponseExt on ExpressionResponse {
  String get thumbnailSmall {
    if (expressionData is PhotoFormExpression) {
      final data = expressionData as PhotoFormExpression;
      if (data.thumbnail300 != null && data.thumbnail300.isNotEmpty) {
        return data.thumbnail300;
      }
      if (data.thumbnail600 != null && data.thumbnail600.isNotEmpty) {
        return data.thumbnail600;
      }
      return data.image;
    }
    if (expressionData is AudioFormExpression) {
      final data = expressionData as AudioFormExpression;
      if (data.thumbnail300 != null && data.thumbnail300.isNotEmpty) {
        return data.thumbnail300;
      }
      if (data.thumbnail600 != null && data.thumbnail600.isNotEmpty) {
        return data.thumbnail600;
      }
      return data.photo;
    }
    if (expressionData is EventFormExpression) {
      final data = expressionData as EventFormExpression;
      if (data.thumbnail300 != null && data.thumbnail300.isNotEmpty) {
        return data.thumbnail300;
      }
      if (data.thumbnail600 != null && data.thumbnail600.isNotEmpty) {
        return data.thumbnail600;
      }
      return data.photo;
    }
    throw JuntoException("Image not found", 404);
  }

  String get thumbnailLarge {
    if (expressionData is PhotoFormExpression) {
      final data = expressionData as PhotoFormExpression;
      if (data.thumbnail600 != null && data.thumbnail600.isNotEmpty) {
        return data.thumbnail600;
      }
      return data.image;
    }
    if (expressionData is AudioFormExpression) {
      final data = expressionData as AudioFormExpression;

      if (data.thumbnail600 != null && data.thumbnail600.isNotEmpty) {
        return data.thumbnail600;
      }
      return data.photo;
    }
    if (expressionData is EventFormExpression) {
      final data = expressionData as EventFormExpression;

      if (data.thumbnail600 != null && data.thumbnail600.isNotEmpty) {
        return data.thumbnail600;
      }
      return data.photo;
    }
    throw JuntoException("Image not found", 404);
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
    this.mentions,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      address: json['address'],
      type: json['type'],
      expressionData: ExpressionResponse.generateExpressionData(
        json['type'],
        json['expression_data'],
      ),
      creator: UserProfile.fromJson(json['creator']),
      comments: json['comments'],
      resonations: json['resonations'],
      createdAt: RFC3339.parseRfc3339(json['created_at']),
      privacy: json['privacy'],
      context: json['context'],
      mentions: json['mentions'] ?? [],
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
  final List<dynamic> mentions;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'address': address,
        'type': type,
        'expression_data': expressionData.toJson(),
        'creator': creator.toJson(),
        'comments': comments,
        'resonations': resonations,
        'created_at': createdAt.toIso8601String(),
        'privacy': privacy,
        'context': context,
        'mentions': mentions,
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
    this.resultCount,
  });

  final List<T> results;
  final String lastTimestamp;
  final int resultCount;
}

class Channel with RFC3339 {
  const Channel({
    @required this.name,
    this.createdAt,
  });

  factory Channel.fromJson(Map<String, dynamic> map) {
    return Channel(
      name: map['name'] as String,
      createdAt: RFC3339.parseRfc3339(map['created_at']),
    );
  }

  final String name;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return <String, String>{
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() => name;
}
