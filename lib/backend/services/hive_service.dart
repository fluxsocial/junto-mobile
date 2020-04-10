import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:path_provider/path_provider.dart';

abstract class LocalCache {
  Future<void> insertExpressions(List<ExpressionResponse> expressions);

  Future<List<ExpressionResponse>> retriveExpressions();
}

class HiveCache implements LocalCache {
  HiveCache(this.boxName) {
    init();
  }

  final String boxName;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(ExpressionModelAdapter());
  }

  @override
  Future<void> insertExpressions(List<ExpressionResponse> expressions) async {
    for (ExpressionResponse expression in expressions) {
      final box = await Hive.openBox('expressions');
      box.put(expression.address, expression)
    }
  }

  @override
  Future<List<ExpressionResponse>> retriveExpressions() {
    // TODO: implement retriveExpressions
    throw UnimplementedError();
  }
}
