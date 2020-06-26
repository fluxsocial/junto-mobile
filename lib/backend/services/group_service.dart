import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/sphere.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:meta/meta.dart';

@immutable
class GroupServiceCentralized implements GroupService {
  const GroupServiceCentralized(this.client);

  final JuntoHttp client;

  @override
  Future<SphereResponse> createSphere(
    SphereModel sphere,
  ) async {
    final Map<String, dynamic> _postBody = sphere.toJson();
    final http.Response _serverResponse = await client.postWithoutEncoding(
      '/groups',
      body: _postBody,
    );
    final Map<String, dynamic> _decodedResponse =
        JuntoHttp.handleResponse(_serverResponse);

    return SphereResponse.fromJson(_decodedResponse);
  }

  @override
  Future<void> deleteGroup(String groupAddress) async {
    await client.delete('/groups/$groupAddress');
  }

  @override
  Future<Group> getGroup(String groupAddress) async {
    final http.Response _serverResponse =
        await client.get('/groups/$groupAddress');
    final Map<String, dynamic> _data =
        JuntoHttp.handleResponse(_serverResponse);
    return Group.fromJson(_data);
  }

  @override
  Future<Map<String, dynamic>> getRelationToGroup(
      String groupAddress, String userAddress) async {
    final http.Response _serverResponse =
        await client.get('/groups/$groupAddress/members/$userAddress');
    final Map<String, dynamic> _data =
        JuntoHttp.handleResponse(_serverResponse);
    return _data;
  }

  @override
  Future<void> addGroupMember(
      String groupAddress, List<Map<String, dynamic>> users) async {
    final http.Response _serverResponse = await client
        .postWithoutEncoding('/groups/$groupAddress/members', body: users);
    JuntoHttp.handleResponse(_serverResponse);
  }

  @override
  Future<void> removeGroupMember(
      String groupAddress, String userAddress) async {
    final Map<String, String> _postBody = <String, String>{
      'user_address': userAddress,
    };
    final http.Response _serverResponse = await client.delete(
      '/groups/$groupAddress/members',
      body: <dynamic>[_postBody],
    );
    if (_serverResponse.statusCode != 200) {
      JuntoHttp.handleResponse(_serverResponse);
    }
  }

  @override
  List<Sphere> get spheres => Sphere.fetchAll();

  @override
  Future<QueryResults<Users>> getGroupMembers(
      String groupAddress, ExpressionQueryParams params) async {
    final http.Response _serverResponse = await client
        .get('/groups/$groupAddress/members', queryParams: params.toJson());
    final Map<String, dynamic> items =
        await JuntoHttp.handleResponse(_serverResponse);

    return QueryResults(
      lastTimestamp: items['last_timestamp'],
      results: [
        for (dynamic data in items['results']) Users.fromJson(data),
      ],
    );
  }

  @override
  Future<List<ExpressionResponse>> getGroupExpressions(
    String groupAddress,
    GroupExpressionQueryParams params,
  ) async {
    final http.Response _serverResponse = await client
        .get('/groups/$groupAddress/expressions', queryParams: <String, String>{
      'direct_expressions': params.directExpressions.toString(),
      'direct_expression_pagination_position':
          params.directExpressionPaginationPosition.toString(),
    });

    final Map<String, dynamic> items =
        JuntoHttp.handleResponse(_serverResponse);
    return (items['direct_posts']['results'] as List<dynamic>)
        .map((dynamic data) => ExpressionResponse.fromJson(data))
        .toList();
  }

  @override
  Future<Group> updateGroup(Group group) async {
    final http.Response _serverResponse = await client.patch(
      '/groups/${group.address}',
      body: group.groupData.toJson(),
    );
    final Map<String, dynamic> _data =
        JuntoHttp.handleResponse(_serverResponse);
    return Group.fromJson(_data);
  }

  @override
  Future<void> respondToGroupRequest(String groupAddress, bool decision) async {
    final http.Response _serverResponse = await client.postWithoutEncoding(
      '/groups/$groupAddress/respond',
      body: <String, dynamic>{
        'status': decision,
      },
    );
    JuntoHttp.handleResponse(_serverResponse);
  }
}
