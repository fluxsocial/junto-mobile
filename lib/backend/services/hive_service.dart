import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/services.dart' show LocalCache;
import 'package:junto_beta_mobile/hive_keys.dart';
import 'package:junto_beta_mobile/models/models.dart';

class HiveCache implements LocalCache {
  HiveCache() {
    init();
  }

  Future<void> init() async {
    Hive.registerAdapter(ExpressionResponseAdapter());
    Hive.registerAdapter(ShortFormExpressionAdapter());
    Hive.registerAdapter(PhotoFormExpressionAdapter());
    Hive.registerAdapter(LongFormExpressionAdapter());
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(AudioFormExpressionAdapter());
    Hive.registerAdapter(JuntoNotificationAdapter());
  }

  final _supportedBox = <DBBoxes, String>{
    DBBoxes.collectiveExpressions: HiveBoxes.kExpressions,
    DBBoxes.packExpressions: HiveBoxes.kPack,
    DBBoxes.denExpressions: HiveBoxes.kDen,
    DBBoxes.notifications: HiveBoxes.kNotifications,
  };

  @override
  Future<void> insertExpressions(
      List<ExpressionResponse> expressions, DBBoxes db) async {
    final box = await Hive.openLazyBox<ExpressionResponse>(_supportedBox[db]);
    final _futures = <Future>[];
    for (ExpressionResponse expression in expressions) {
      if (!box.containsKey(expression.address)) {
        _futures.add(box.put(expression.address, expression));
      }
    }
    await Future.wait(_futures);
  }

  @override
  Future<List<ExpressionResponse>> retrieveExpressions(DBBoxes db) async {
    final box = await Hive.openLazyBox<ExpressionResponse>(_supportedBox[db]);
    List<ExpressionResponse> items = [];
    for (dynamic key in box.keys) {
      ExpressionResponse res = await box.get(key);
      items.add(res);
    }
    items.sort((a, b) => -a.createdAt.compareTo(b.createdAt));
    return items;
  }

  @override
  Future<void> insertNotifications(List<JuntoNotification> notifications,
      {bool overwrite}) async {
    try {
      final box = await Hive.openLazyBox<JuntoNotification>(
          _supportedBox[DBBoxes.notifications]);
      final _futures = <Future>[];
      for (JuntoNotification notification in notifications) {
        if (overwrite == true) {
          _futures.add(box.put(notification.address, notification));
        } else if (!box.containsKey(notification.address)) {
          _futures.add(box.put(notification.address, notification));
        }
      }
      await Future.wait(_futures);
    } catch (e) {
      print('inserting notifs went wrong');
      logger.logException(e);
    }
  }

  @override
  Future<List<JuntoNotification>> retrieveNotifications() async {
    try {
      final box = await Hive.openLazyBox<JuntoNotification>(
          _supportedBox[DBBoxes.notifications]);
      List<JuntoNotification> items = [];
      for (String key in box.keys) {
        key.toString();
        JuntoNotification res = await box.get(key);
        items.add(res);
      }
      if (items.length > 0) {
        items.sort((a, b) => -a?.createdAt?.compareTo(b?.createdAt));
      }
      //TODO: remove if number of items exceeds 100
      return items;
    } catch (e) {
      logger.logException(e);
      return [];
    }
  }

  @override
  Future<void> deleteNotification(String notificationKey) async {
    try {
      final box = await Hive.openLazyBox<JuntoNotification>(
          _supportedBox[DBBoxes.notifications]);
      box.delete(notificationKey);
    } catch (error) {
      print(error);
    }
  }

  Future<void> wipe() async {
    try {
      if (Hive.isBoxOpen(HiveBoxes.kExpressions)) {
        final exp =
            await Hive.lazyBox<ExpressionResponse>(HiveBoxes.kExpressions);
        await exp.deleteAll(exp.keys);
      } else {
        final exp =
            await Hive.openLazyBox<ExpressionResponse>(HiveBoxes.kExpressions);
        await exp.deleteAll(exp.keys);
      }
    } catch (e) {
      logger.logException(e);
    }

    try {
      if (Hive.isBoxOpen(HiveBoxes.kDen)) {
        final den = await Hive.lazyBox<ExpressionResponse>(HiveBoxes.kDen);
        await den.deleteAll(den.keys);
      } else {
        final den = await Hive.openLazyBox<ExpressionResponse>(HiveBoxes.kDen);
        await den.deleteAll(den.keys);
      }
    } catch (e) {
      logger.logException(e);
    }

    try {
      if (Hive.isBoxOpen(HiveBoxes.kPack)) {
        final pack = await Hive.lazyBox<ExpressionResponse>(HiveBoxes.kPack);
        await pack.deleteAll(pack.keys);
      } else {
        final pack =
            await Hive.openLazyBox<ExpressionResponse>(HiveBoxes.kPack);
        await pack.deleteAll(pack.keys);
      }
    } catch (e) {
      logger.logException(e);
    }

    try {
      if (Hive.isBoxOpen(HiveBoxes.kNotifications)) {
        final notif =
            await Hive.lazyBox<JuntoNotification>(HiveBoxes.kNotifications);
        await notif.deleteAll(notif.keys);
      } else {
        final notif =
            await Hive.openLazyBox<JuntoNotification>(HiveBoxes.kNotifications);
        await notif.deleteAll(notif.keys);
      }
    } catch (e) {
      logger.logException(e);
    }

    try {
      if (Hive.isBoxOpen(HiveBoxes.kAppBox)) {
        final app = await Hive.lazyBox(HiveBoxes.kAppBox);
        await app.deleteAll(app.keys);
      } else {
        final app = await Hive.openLazyBox(HiveBoxes.kAppBox);
        await app.deleteAll(app.keys);
      }
    } catch (e) {
      logger.logException(e);
    }
  }
}
