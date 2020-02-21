import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/notification_model.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';

@immutable
class NotificationServiceImpl implements NotificationService {
  const NotificationServiceImpl(this.httpClient);

  final JuntoHttp httpClient;

  @override
  Future<NotificationResultsModel> getNotifications(
    NotificationQuery params,
  ) async {
    final http.Response response = await httpClient.get(
      '/notifications',
      queryParams: params.toMap(),
    );

    final Map<String, dynamic> data = JuntoHttp.handleResponse(response);
    return NotificationResultsModel.fromMap(data);
  }
}
