import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:junto_beta_mobile/models/models.dart';

abstract class LocalCache {
  Future<void> insertExpressions(List<ExpressionResponse> expressions);

  Future<List<ExpressionResponse>> retrieveExpressions();
}

class HiveCache implements LocalCache {
  HiveCache() {
    init();
  }

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ExpressionResponseAdapter());
    Hive.registerAdapter(ShortFormExpressionAdapter());
    Hive.registerAdapter(PhotoFormExpressionAdapter());
    Hive.registerAdapter(LongFormExpressionAdapter());
    Hive.registerAdapter(UserProfileAdapter());
  }

  @override
  Future<void> insertExpressions(List<ExpressionResponse> expressions) async {
    final box = await Hive.openLazyBox<ExpressionResponse>('expressions');
    final _futures = <Future>[];
    for (ExpressionResponse expression in expressions) {
      if (!box.containsKey(expression.address)) {
        _futures.add(box.put(expression.address, expression));
      }
    }
    await Future.wait(_futures);
  }

  @override
  Future<List<ExpressionResponse>> retrieveExpressions() async {
    final box = await Hive.openLazyBox<ExpressionResponse>('expressions');
    List<ExpressionResponse> items = [];
    for (dynamic key in box.keys) {
      ExpressionResponse res = await box.get(key);
      items.add(res);
    }
    items.sort((a, b) => -a.createdAt.compareTo(b.createdAt));
    return items;
  }
}
