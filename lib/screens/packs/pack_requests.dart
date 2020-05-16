import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/bloc/group_bloc.dart';
import 'package:junto_beta_mobile/widgets/previews/pack_preview/pack_request.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';
import 'package:provider/provider.dart';

class PackRequests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsHandler>(
      builder: (context, data, child) {
        final notifications = data.notifications;
        if (notifications.length > 0) {
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final item = notifications[index];
              if (notifications.length > 0 &&
                  item.notificationType == NotificationType.GroupJoinRequest) {
                if (item.group.groupType == 'Pack') {
                  return PackRequest(
                    userProfile: item.creator,
                    pack: item.group,
                    refreshGroups: () async {
                      await context.bloc<GroupBloc>().add(
                            FetchMyPack(),
                          );
                    },
                  );
                }
              }
              return const SizedBox();
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
