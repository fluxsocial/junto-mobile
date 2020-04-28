import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/services.dart' show LocalCache;
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
  }

  final _supportedBox = <DBBoxes, String>{
    DBBoxes.collectiveExpressions: "expressions",
    DBBoxes.packExpressions: "pack",
    DBBoxes.denExpressions: "den",
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
}
