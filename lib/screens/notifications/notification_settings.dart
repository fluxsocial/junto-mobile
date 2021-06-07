import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/theme/custom_icons.dart';
import 'package:junto_beta_mobile/backend/repositories/notification_repo.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/notifications/bloc/notification_bloc.dart';
import 'package:junto_beta_mobile/widgets/settings_popup.dart';
import 'package:provider/provider.dart';

class NotificationSettingScreen extends StatefulWidget {
  @override
  _NotificationSettingScreenState createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> configureNotifications() async {
    final notificationRepo = Provider.of<NotificationRepo>(context);

    final granted = await notificationRepo.requestPermissions();

    if (!granted) {
      showDialog(
        context: context,
        builder: (context) => SettingsPopup(
          buildContext: context,
          // TODO: @Eric - Need to update the text
          text: 'Access not granted for notifications',
          onTap: AppSettings.openNotificationSettings,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          brightness: Theme.of(context).brightness,
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          titleSpacing: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: .75,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).dividerColor,
            ),
          ),
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    color: Colors.transparent,
                    alignment: Alignment.centerLeft,
                    child: Icon(CustomIcons.back, size: 20),
                  ),
                ),
                Text(
                  S.of(context).notifications_title,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(width: 42)
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<NotificationSettingBloc, NotificationSettingState>(
        builder: (context, state) {
          final data = state is NotificationSettingLoaded
              ? state.notificationSettings
              : NotificationPrefsModel.disabled();

          return Container(
            child: ListView(
              children: [
                NotificationSettingsItem(
                  title: 'Comment',
                  value: data.comment,
                  onChanged: (val) {
                    final notifs = data.copyWith(comment: val);

                    context
                        .read<NotificationSettingBloc>()
                        .add(UpdateNotificationSetting(options: notifs));
                  },
                ),
                NotificationSettingsItem(
                  title: 'Connection',
                  value: data.connection,
                  onChanged: (val) {
                    final notifs = data.copyWith(connection: val);

                    context
                        .read<NotificationSettingBloc>()
                        .add(UpdateNotificationSetting(options: notifs));
                  },
                ),
                NotificationSettingsItem(
                  title: 'Connection Request',
                  value: data.connectionRequest,
                  onChanged: (val) {
                    final notifs = data.copyWith(connectionRequest: val);

                    context
                        .read<NotificationSettingBloc>()
                        .add(UpdateNotificationSetting(options: notifs));
                  },
                ),
                NotificationSettingsItem(
                  title: 'General',
                  value: data.general,
                  onChanged: (val) {
                    final notifs = data.copyWith(general: val);

                    context
                        .read<NotificationSettingBloc>()
                        .add(UpdateNotificationSetting(options: notifs));
                  },
                ),
                NotificationSettingsItem(
                  title: 'Group Join Request',
                  value: data.groupJoinRequest,
                  onChanged: (val) {
                    final notifs = data.copyWith(groupJoinRequest: val);

                    context
                        .read<NotificationSettingBloc>()
                        .add(UpdateNotificationSetting(options: notifs));
                  },
                ),
                NotificationSettingsItem(
                  title: 'Mention',
                  value: data.mention,
                  onChanged: (val) {
                    final notifs = data.copyWith(mention: val);

                    context
                        .read<NotificationSettingBloc>()
                        .add(UpdateNotificationSetting(options: notifs));
                  },
                ),
                NotificationSettingsItem(
                  title: 'Pack Relation',
                  value: data.packRelation,
                  onChanged: (val) {
                    final notifs = data.copyWith(packRelation: val);

                    context
                        .read<NotificationSettingBloc>()
                        .add(UpdateNotificationSetting(options: notifs));
                  },
                ),
                NotificationSettingsItem(
                  title: 'Subscribe',
                  value: data.subscribe,
                  onChanged: (val) {
                    final notifs = data.copyWith(subscribe: val);

                    context
                        .read<NotificationSettingBloc>()
                        .add(UpdateNotificationSetting(options: notifs));
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NotificationSettingsItem extends StatelessWidget {
  const NotificationSettingsItem({
    Key key,
    @required this.title,
    @required this.value,
    this.onChanged,
  }) : super(key: key);

  final String title;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: .75,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Switch(value: value, onChanged: onChanged)
        ],
      ),
    );
  }
}
