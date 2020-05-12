//ignore_for_file:implementation_imports
import 'package:file/file.dart' as f;
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:file/src/interface/directory.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cache_manager/src/cache_store.dart';
import 'package:flutter_cache_manager/src/storage/cache_object.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class CustomCacheManager extends BaseCacheManager {
  static const key = "customCache";

  static CustomCacheManager _instance;

  factory CustomCacheManager() {
    if (_instance == null) {
      _instance = CustomCacheManager._();
    }
    return _instance;
  }

  CustomCacheManager._()
      : super(
          key,
          cacheStore: PresignedFilesCacheStore(
            _createFileDir(),
            key,
            200,
            Duration(days: 7),
          ),
        );

  @override
  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }

  static Future<String> _getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }

  static Future<f.Directory> _createFileDir() async {
    var fs = const LocalFileSystem();
    var directory = fs.directory((await _getFilePath()));
    await directory.create(recursive: true);
    return directory;
  }
}

class PresignedFilesCacheStore extends CacheStore {
  PresignedFilesCacheStore(
    Future<Directory> basedir,
    String storeKey,
    int capacity,
    Duration maxAge,
  ) : super(basedir, storeKey, capacity, maxAge);

  String imageId(String url) {
    return '${Uri.parse(url).path}';
  }

  @override
  Future<FileInfo> getFile(String url) async {
    final id = imageId(url);
    return await super.getFile(id);
  }

  @override
  Future<void> putFile(CacheObject cacheObject) async {
    final url = imageId(cacheObject.url);
    cacheObject.url = url;
    await super.putFile(cacheObject);
  }

  @override
  Future<CacheObject> retrieveCacheData(String url) {
    final id = imageId(url);
    return super.retrieveCacheData(id);
  }

  FileInfo getFileFromMemory(String url) {
    final id = imageId(url);
    return super.getFileFromMemory(id);
  }
}
