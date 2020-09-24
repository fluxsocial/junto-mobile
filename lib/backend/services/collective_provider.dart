import 'package:dio/dio.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/collective.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:meta/meta.dart';

@immutable
class CollectiveProviderCentralized implements CollectiveService {
  const CollectiveProviderCentralized(this.client);

  final JuntoHttp client;

  @override
  Future<Collective> createCollection(String name, String privacy,
      [String parent]) async {
    final Response _response =
        await client.postWithoutEncoding('/collection', body: <String, String>{
      'name': name,
      'privacy': privacy,
      'parent': parent,
    });
    final _map = JuntoHttp.handleResponse(_response);
    return Collective.fromJson(_map);
  }

  @override
  Future<CollectionResponse> getCollection(String collectionAddress) async {
    final Response _response =
        await client.get('/collection/$collectionAddress');
    final _map = JuntoHttp.handleResponse(_response);
    return CollectionResponse.fromJson(_map);
  }

  @override
  Future<void> postCollectiveExpression(
      String collectionAddress, String expressionAddress) async {
    final Response _response = await client.postWithoutEncoding(
        '/collection/$collectionAddress/$expressionAddress');
    JuntoHttp.handleResponse(_response);
  }
}
