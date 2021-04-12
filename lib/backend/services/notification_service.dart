import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';

@immutable
class NotificationServiceImpl implements NotificationService {
  NotificationServiceImpl(this.httpClient);

  final JuntoHttp httpClient;
  final FirebaseMessaging _messaging = FirebaseMessaging();

  @override
  Future<JuntoNotificationResults> getJuntoNotifications(
      NotificationQuery params) async {
    try {
      logger.logInfo('Fetching notifications from API');
      final Response response = await httpClient.get(
        '/notifications',
        queryParams: params.toJson(),
      );

      print('User notifications');
      print(response);

      final Map<String, dynamic> data = JuntoHttp.handleResponse(response);
      final result = JuntoNotificationResults.fromJson(data);

      return result.copyWith(wasSuccessful: true);
    } on JuntoException catch (e) {
      logger.logError(
          'Error while fetching notifications due to ${e.message} ${e.errorCode}');
      return JuntoNotificationResults(wasSuccessful: false);
    } catch (e, s) {
      logger.logException(e, s, 'Error while fetching notifications');

      return JuntoNotificationResults(wasSuccessful: false);
    }
  }

  @override
  Future<String> getFCMToken() async {
    return await _messaging.getToken();
  }

  @override
  Future<bool> requestPermissions() async {
    try {
      return await _messaging.requestNotificationPermissions();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> registerDevice(final String fcmToken) async {
    try {
      await httpClient.postWithoutEncoding('/notifications/register', body: {
        'device_token': fcmToken,
      });
      return;
    } catch (e) {
      print(e);
      return;
    }
  }

  @override
  Future<void> unRegisterDevice(final String fcmToken) async {
    try {
      await httpClient.postWithoutEncoding('/notifications/deregister', body: {
        'device_token': fcmToken,
      });
      return;
    } catch (e) {
      return;
    }
  }

  @override
  Future<void> manageNotifications(NotificationPrefsModel options) async {
    try {
      await httpClient.postWithoutEncoding('/notifications/manage',
          body: options.toMap());
    } catch (e) {
      throw JuntoException('Unable to update notification prefs', -1);
    }
  }

  @override
  Future<NotificationPrefsModel> getNotificationsPrefs() async {
    try {
      final response = await httpClient.get('/notifications/manage');
      return NotificationPrefsModel.fromMap(response.data);
    } catch (e) {
      throw JuntoException('Unable to retrieve notification prefs', -1);
    }
  }
}
