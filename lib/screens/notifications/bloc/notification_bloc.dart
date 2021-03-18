import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/repositories/notification_repo.dart';
import 'package:junto_beta_mobile/models/junto_notification.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationSettingBloc
    extends Bloc<NotificationSettingEvent, NotificationSettingState> {
  NotificationSettingBloc(this.notificationRepo)
      : super(NotificationSettingInitial());

  final NotificationRepo notificationRepo;

  @override
  Stream<NotificationSettingState> mapEventToState(
    NotificationSettingEvent event,
  ) async* {
    if (event is FetchNotificationSetting) {
      yield* _mapFetchNotificationSettingToState();
    } else if (event is UpdateNotificationSetting) {
      yield* _mapUpdateNotificationSettingToState(event);
    }
  }

  Stream<NotificationSettingState>
      _mapFetchNotificationSettingToState() async* {
    try {
      yield NotificationSettingLoading();

      final result = await notificationRepo.getNotificationsPrefs();

      yield NotificationSettingLoaded(notificationSettings: result);
    } catch (e, s) {
      logger.logException(e, s);
      yield NotificationSettingError();
    }
  }

  Stream<NotificationSettingState> _mapUpdateNotificationSettingToState(
      UpdateNotificationSetting event) async* {
    try {
      yield NotificationSettingLoaded(notificationSettings: event.options);

      await notificationRepo.manageNotifications(event.options);
    } catch (e, s) {
      logger.logException(e, s);
      yield NotificationSettingError();
    }
  }
}
