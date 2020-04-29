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
        if (map['connection_notifications'] != null)
          for (Map<String, dynamic> data in map['connection_notifications'])
            UserProfile.fromMap(data)
      ],
      groupJoinNotifications: <Group>[
        if (map['group_join_notifications'] != null)
          for (Map<String, dynamic> data in map['group_join_notifications']
              ['results'])
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

class NotificationQuery {
  const NotificationQuery({
    this.paginationPosition,
    this.connectionRequests,
    this.groupJoinRequests,
    this.lastTimestamp,
  });

  final int paginationPosition;
  final bool connectionRequests;
  final bool groupJoinRequests;
  final String lastTimestamp;

  Map<String, String> toMap() {
    return <String, String>{
      'pagination_position': '$paginationPosition',
      'connection_requests': '$connectionRequests',
      'group_join_requests': '$groupJoinRequests',
      if (lastTimestamp != null) 'last_timestamp': '$lastTimestamp',
    };
  }
}
