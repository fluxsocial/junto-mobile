import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/junto_notification_results.dart';
import 'package:junto_beta_mobile/models/notification_model.dart';

class NotificationRepo {
  NotificationRepo(this.service);

  final NotificationService service;

  Future<NotificationResultsModel> getNotifications(NotificationQuery params) {
    return service.getNotifications(params);
  }

  Future<JuntoNotificationResults> getJuntoNotifications({
    int page = 0,
    String lastTimestamp,
    bool connectionRequests = true,
    bool groupJoinRequests = true,
  }) async {
    try {
      final result = await service.getJuntoNotifications(
        NotificationQuery(
          groupJoinRequests: groupJoinRequests,
          connectionRequests: connectionRequests,
          paginationPosition: page,
          lastTimestamp: lastTimestamp,
        ),
      );
      if (result.wasSuccessful) {
        //TODO store in cache
        //TODO merge result with cache (read/unread)
        //return new
      } else {
        //TODO try to return from cache
        //if not then just return failed attempt
        if (true) {
          //return cached
        } else {
          logger.logError('Couldn\'t retrieve notifications from cache');
          return JuntoNotificationResults([], wasSuccessful: false);
        }
      }
      return result;
    } catch (e, s) {
      logger.logException(e, s, 'Error while retrieving notifications');
      return JuntoNotificationResults([], wasSuccessful: false);
    }
  }
}
