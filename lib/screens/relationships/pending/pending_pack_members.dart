import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/screens/groups/bloc/group_bloc.dart';
import 'package:junto_beta_mobile/widgets/previews/pack_preview/pack_request.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';
import 'package:junto_beta_mobile/widgets/placeholders/feed_placeholder.dart';

class PendingPackMembers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsHandler>(
      builder: (context, data, child) {
        final notifications = data.notifications;
        final packNotification = notifications
            .where((element) =>
                element.notificationType == NotificationType.GroupJoinRequest &&
                element.group.groupType == 'Pack')
            .toList();
        if (packNotification.length > 0) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: packNotification.length,
            itemBuilder: (context, index) {
              final item = packNotification[index];
              return PackRequest(
                userProfile: item.creator,
                pack: item.group,
                refreshGroups: () async {
                  await context.read<GroupBloc>().add(
                        FetchMyPack(),
                      );
                },
              );
            },
          );
        } else {
          return FeedPlaceholder(
            placeholderText: 'No pack requests yet!',
            image: 'assets/images/junto-mobile__bench.png',
          );
        }
      },
    );
  }
}
