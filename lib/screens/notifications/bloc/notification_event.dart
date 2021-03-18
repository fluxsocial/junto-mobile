part of 'notification_bloc.dart';

@immutable
abstract class NotificationSettingEvent {}

class FetchNotificationSetting extends NotificationSettingEvent {}

class UpdateNotificationSetting extends NotificationSettingEvent {
  UpdateNotificationSetting({
    this.options,
  });

  final NotificationPrefsModel options;
}
