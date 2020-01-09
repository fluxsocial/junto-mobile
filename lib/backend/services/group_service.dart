import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/sphere.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class GroupServiceCentralized implements GroupService {
  const GroupServiceCentralized(this.client);

  final JuntoHttp client;

  @override
  Future<CentralizedSphereResponse> createSphere(
    CentralizedSphere sphere,
  ) async {
    final Map<String, dynamic> _postBody = sphere.toMap();
    final http.Response _serverResponse = await client.postWithoutEncoding(
      '/groups',
      body: _postBody,
    );
    final Map<String, dynamic> _decodedResponse =
        JuntoHttp.handleResponse(_serverResponse);
    return CentralizedSphereResponse.fromJson(_decodedResponse);
  }

  @override
  Future<Group> getGroup(String groupAddress) async {
    final http.Response _serverResponse =
        await client.get('/groups/$groupAddress');
    final Map<String, dynamic> _data =
        JuntoHttp.handleResponse(_serverResponse);
    return Group.fromMap(_data);
  }

  @override
  Future<void> addGroupMember(
      String groupAddress, List<Map<String, dynamic>> users) async {
    final http.Response _serverResponse = await client.postWithoutEncoding(
      '/groups/$groupAddress/members',
      body: users,
    );
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
  Future<List<Users>> getGroupMembers(String groupAddress) async {
    final http.Response _serverResponse =
        await client.get('/groups/$groupAddress/members');
    final List<dynamic> items = JuntoHttp.handleResponse(_serverResponse);
    return items
        .map(
          (dynamic data) => Users.fromJson(data),
        )
        .toList();
  }

  @override
  Future<List<CentralizedExpressionResponse>> getGroupExpressions(
    String groupAddress,
    ExpressionQueryParams params,
  ) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String authKey = _prefs.getString('auth');
    final Uri _uri = Uri.http(
      END_POINT,
      '/groups/$groupAddress/expressions',
      <String, String>{'direct_expressions': 'true'},
    );
    final http.Response _serverResponse = await http.get(
      _uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'cookie': 'auth=$authKey',
      },
    );

    final Map<String, dynamic> items =
        JuntoHttp.handleResponse(_serverResponse);
    return (items['direct_posts'] as List<dynamic>)
        .map((dynamic data) => CentralizedExpressionResponse.fromMap(data))
        .toList();
  }

  @override
  Future<Group> updateGroup(Group group) async {
    final http.Response _serverResponse =
        await client.postWithoutEncoding('/groups/${group.address}');
    final Map<String, dynamic> _data =
        JuntoHttp.handleResponse(_serverResponse);
    return Group.fromMap(_data);
  }
}
