import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager {
  static const key = "customCache";

  static CacheManager instance = CacheManager(Config(
    key,
    maxNrOfCacheObjects: 200,
    stalePeriod: Duration(days: 7),
    repo: JsonCacheInfoRepository(databaseName: key),
    fileService: HttpFileService(),
  ));
}
