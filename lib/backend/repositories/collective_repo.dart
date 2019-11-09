import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';

class CollectiveRepo {
  CollectiveRepo(this._collectiveService);

  final CollectiveService _collectiveService;

  Future<Collective> createCollection(String name, String privacy,
      [String parent]) {
    return _collectiveService.createCollection(name, privacy);
  }

  Future<CollectionResponse> getCollection(
    String collectionAddress,
  ) {
    return _collectiveService.getCollection(collectionAddress);
  }

  Future<void> postCollectiveExpression(
    String collectionAddress,
    String expressionAddress,
  ) {
    return _collectiveService.postCollectiveExpression(
      collectionAddress,
      expressionAddress,
    );
  }
}
