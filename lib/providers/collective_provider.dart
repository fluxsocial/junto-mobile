import 'package:http/io_client.dart';
import 'package:junto_beta_mobile/models/collective.dart';
import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/utils/junto_http.dart';

abstract class CollectiveProvider {
  /// Creates a collection with the given arguments.
  Future<Collective> createCollection(String name, String privacy, [String parent]);

  /// Returns the [CollectionResponse] for the given [collectionAddress]
  Future<CollectionResponse> getCollection(String collectionAddress);

  /// Adds the given [expressionAddress] to the collective [collectionAddress]
  Future<void> postCollectiveExpression(String collectionAddress, String expressionAddress);
}

class CollectiveProviderCentralized implements CollectiveProvider {
  CollectiveProviderCentralized([http.Client _client]) {
    client = JuntoHttp(httpClient: _client ??= IOClient());
  }
  JuntoHttp client;
  @override
  Future<Collective> createCollection(String name, String privacy, [String parent]) async {
    final http.Response _response = await client.postWithoutEncoding('/collection', body: <String, String>{
      'name': name,
      'privacy': privacy,
      'parent': parent,
    });
    final Map<String, dynamic> _map = JuntoHttp.handleResponse(_response);
    return Collective.fromMap(_map);
  }

  @override
  Future<CollectionResponse> getCollection(String collectionAddress) async {
    final http.Response _response = await client.get('/collection/$collectionAddress');
    final Map<String, dynamic> _map = JuntoHttp.handleResponse(_response);
    return CollectionResponse.fromMap(_map);
  }

  @override
  Future<void> postCollectiveExpression(String collectionAddress, String expressionAddress) async {
    final http.Response _response = await client.post('/collection/$collectionAddress/$expressionAddress');
    JuntoHttp.handleResponse(_response);
  }
}
