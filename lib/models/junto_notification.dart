import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

import 'expression_slim_model.dart';

part 'junto_notification.freezed.dart';
part 'junto_notification.g.dart';

enum NotificationType {
  ConnectionNotification,
  GroupJoinRequest,
  NewComment,
  NewSubscription,
  NewConnection,
  NewPackJoin,
}

//We store notifications list in Hive as json not as an object
/// JuntoNotification model retrieved from API and used in views to show in app notifications
///
/// Depending on type there can be different fields available
///
/// - For [NotificationType.connectionNotification] it's [user]
/// - For [NotificationType.groupJoinRequests] it's [group] and [creator]
/// - For [NotificationType.newComment] it's [user] and [expression]
/// - For [NotificationType.newSubscription] it's [user]
/// - For [NotificationType.newConnection] it's [user]
/// - For [NotificationType.newPackJoin] it's [user]
@freezed
abstract class JuntoNotification with _$JuntoNotification {
  factory JuntoNotification(
    String address,
    NotificationType notificationType,
    DateTime createdAt, {
    @JsonKey(fromJson: JuntoNotification.userFromJson, toJson: JuntoNotification.userToJson)
        UserProfile user,
    @JsonKey(fromJson: JuntoNotification.groupFromJson, toJson: JuntoNotification.groupToJson)
        Group group,
    @JsonKey(fromJson: JuntoNotification.userFromJson, toJson: JuntoNotification.userToJson)
        UserProfile creator,
    ExpressionSlimModel commentExpression,
    ExpressionSlimModel sourceExpression,
    @Default(true) bool unread,
  }) = _Notification;

  factory JuntoNotification.fromJson(Map<String, dynamic> json) =>
      _$JuntoNotificationFromJson(json);

// These methods are here because in these models there are factory constructors
// and instance methods used for fromMap and toMap calls
  static Group groupFromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Group.fromMap(json);
    }
    return null;
  }

  static Map<String, dynamic> groupToJson(Group obj) => obj?.toJson();
  static UserProfile userFromJson(Map<String, dynamic> json) {
    if (json != null) {
      return UserProfile.fromMap(json);
    }
    return null;
  }

  static Map<String, dynamic> userToJson(UserProfile obj) => obj?.toJson();
}

class JuntoNotificationAdapter extends TypeAdapter<JuntoNotification> {
  @override
  final typeId = 6;

  @override
  JuntoNotification read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    final data = fields[0] as String;
    final notification = JuntoNotification.fromJson(jsonDecode(data));
    return notification;
  }

  @override
  void write(BinaryWriter writer, JuntoNotification obj) {
    final json = jsonEncode(obj.toJson());
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(json);
  }
}
