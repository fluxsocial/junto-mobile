import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';

@immutable
class NotificationServiceImpl implements NotificationService {
  const NotificationServiceImpl(this.httpClient);

  final JuntoHttp httpClient;

  @override
  Future<JuntoNotificationResults> getJuntoNotifications(
      NotificationQuery params) async {
    try {
      logger.logInfo('Fetching notifications from API');
      final http.Response response = await httpClient.get(
        '/notifications',
        queryParams: params.toMap(),
      );
      print(response.body);
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
}
