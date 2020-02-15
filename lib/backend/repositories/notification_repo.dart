import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/notification_model.dart';

class NotificationRepo {
  NotificationRepo(this.service);

  final NotificationService service;

  Future<NotificationResultsModel> getNotifications() {
    return service.getNotifications();
  }
}
