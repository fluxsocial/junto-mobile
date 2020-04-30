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
