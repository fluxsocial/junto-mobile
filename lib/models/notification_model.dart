import 'package:junto_beta_mobile/models/models.dart';
import 'package:meta/meta.dart';

/// Class encapsulating the result sent back for the server's `/notification`
/// endpoint.
class NotificationResultsModel {
  const NotificationResultsModel({
    @required this.connectionNotifications,
    @required this.groupJoinNotifications,
  });

  factory NotificationResultsModel.fromMap(Map<String, dynamic> map) {
    return NotificationResultsModel(
      connectionNotifications: <UserProfile>[
        for (dynamic data in map['connection_notifications'])
          UserProfile.fromMap(data)
      ],
      groupJoinNotifications: <Group>[
        for (dynamic data in map['group_join_notifications'])
          Group.fromMap(data),
      ],
    );
  }

  final List<UserProfile> connectionNotifications;
  final List<Group> groupJoinNotifications;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'connection_notifications': connectionNotifications,
      'group_join_notifications': groupJoinNotifications,
    };
  }
}
