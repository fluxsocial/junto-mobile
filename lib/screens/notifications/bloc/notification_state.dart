part of 'notification_bloc.dart';

@immutable
abstract class NotificationSettingState {}

class NotificationSettingInitial extends NotificationSettingState {}

class NotificationSettingLoading extends NotificationSettingState {}

class NotificationSettingLoaded extends NotificationSettingState {
  NotificationSettingLoaded({
    this.notificationSettings,
  });

  final NotificationPrefsModel notificationSettings;
}

class NotificationSettingError extends NotificationSettingState {
  NotificationSettingError([this.message]);

  final String message;
}

class NotificationSettingEmpty extends NotificationSettingState {}
