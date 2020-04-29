import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

enum NotificationType {
  connectionNotification,
  groupJoinRequests,
  newComment,
  newSubscription,
  newConnection,
  newPackJoin,
}

//We store notifications list in Hive as json not as an object
/// JuntoNotification model retrieved from API and used in views to show in app notifications
///
/// Depending on type there can be different fields available
///
/// - For [NotificationType.connectionNotification] it's [user]
/// - For [NotificationType.groupJoinRequests] it's [group] and [creator]
/// - For [NotificationType.newComment] it's [user]
/// - For [NotificationType.newSubscription] it's [user]
/// - For [NotificationType.newConnection] it's [user]
/// - For [NotificationType.newPackJoin] it's [user]
@freezed
abstract class JuntoNotification with _$JuntoNotification {
  factory JuntoNotification(
    //TODO: add unique id
    NotificationType notificationType,
    DateTime createdAt, {
    @JsonKey(fromJson: JuntoNotification.slimUserFromJson, toJson: JuntoNotification.slimUserToJson)
        SlimUserResponse user,
    @JsonKey(fromJson: JuntoNotification.groupFromJson, toJson: JuntoNotification.groupToJson)
        Group group,
    @JsonKey(fromJson: JuntoNotification.slimUserFromJson, toJson: JuntoNotification.slimUserToJson)
        SlimUserResponse creator,
  }) = _Notification;

  factory JuntoNotification.fromJson(Map<String, dynamic> json) =>
      _$JuntoNotificationFromJson(json);

// These methods are here because in these models there are factory constructors
// and instance methods used for fromMap and toMap calls
  static Group groupFromJson(Map<String, dynamic> json) => Group.fromMap(json);
  static Map<String, dynamic> groupToJson(Group obj) => obj.toMap();
  static SlimUserResponse slimUserFromJson(Map<String, dynamic> json) =>
      SlimUserResponse.fromMap(json);
  static Map<String, dynamic> slimUserToJson(SlimUserResponse obj) =>
      obj.toMap();
}
