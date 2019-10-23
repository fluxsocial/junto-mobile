import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class UserServiceCentralized implements UserService {
  const UserServiceCentralized(this.client);

  final JuntoHttp client;

  /// Creates a [Perspective] on the server. Function takes a single argument.
  @override
  Future<CentralizedPerspective> createPerspective(Perspective perspective) async {
    final Map<String, dynamic> _postBody = <String, dynamic>{'name': perspective.name, 'members': perspective.members};
    final http.Response _serverResponse = await client.postWithoutEncoding(
      '/perspectives',
      body: _postBody,
    );
    final Map<String, dynamic> _body = JuntoHttp.handleResponse(_serverResponse);
    return CentralizedPerspective.fromMap(_body);
  }

  @override
  Future<String> addUserToPerspective(String perspectiveAddress, String userAddress) async {
    throw UnimplementedError('Not implemented in centralized API');
  }

  @override
  Future<UserData> getUser(String userAddress) async {
    final http.Response _serverResponse = await client.get('/users/$userAddress');
    final Map<String, dynamic> _resultMap = JuntoHttp.handleResponse(_serverResponse);
    final UserData _userData = UserData.fromMap(_resultMap);
    return _userData;
  }

  @override
  Future<UserProfile> queryUser(String param, QueryType queryType) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String authKey = _prefs.getString('auth');

    final Uri _uri = Uri.http(
      '198.199.67.10',
      '/users',
      _buildQueryParam(param, queryType),
    );

    final http.Response _serverResponse = await http.get(
      _uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'cookie': 'auth=$authKey',
      },
    );
    if (_serverResponse.statusCode == 200) {
      final Iterable<dynamic> _listData = json.decode(_serverResponse.body);

      if (_listData.isNotEmpty) {
        return UserProfile.fromMap(_listData.first);
      }
      throw const JuntoException('Unable to retrive user profile');
    }
    throw const JuntoException('Forbidden, please log out and log back in');
  }

  @override
  Future<List<CentralizedPerspective>> getUserPerspective(String userAddress) async {
    final http.Response response = await client.get('/users/$userAddress/perspectives');
    final List<dynamic> _listData = json.decode(response.body);
    final List<CentralizedPerspective> _results =
        _listData.map((dynamic data) => CentralizedPerspective.fromMap(data)).toList(growable: false);
    return _results;
  }

  @override
  Future<UserGroupsResponse> getUserGroups(String userAddress) async {
    final http.Response response = await client.get('/users/$userAddress/groups');
    final Map<String, dynamic> _responseMap = JuntoHttp.handleResponse(response);
    return UserGroupsResponse.fromMap(_responseMap);
  }

  @override
  Future<List<CentralizedExpressionResponse>> getUsersResonations(
    String userAddress,
  ) async {
    final http.Response response = await client.get('/users/$userAddress/resonations');
    final List<dynamic> _responseMap = JuntoHttp.handleResponse(response);
    return _responseMap
        .map(
          (dynamic data) => CentralizedExpressionResponse.withCommentsAndResonations(data),
        )
        .toList();
  }

  @override
  Future<List<CentralizedExpressionResponse>> getUsersExpressions(
    String userAddress,
  ) async {
    final http.Response response = await client.get('/users/$userAddress/expressions');
    final List<dynamic> _responseMap = JuntoHttp.handleResponse(response);
    return _responseMap
        .map(
          (dynamic data) => CentralizedExpressionResponse.fromMap(data),
        )
        .toList();
  }

  @override
  Future<UserProfile> readLocalUser() async {
    final LocalStorage _storage = LocalStorage('user-details');
    final bool isReady = await _storage.ready;
    if (isReady) {
      final String _data = _storage.getItem('data');
      final UserProfile profile = UserProfile.fromMap(json.decode(_data));
      return profile;
    }
    throw const JuntoException('Unable to read local user');
  }

  @override
  Future<List<CentralizedPerspective>> userPerspectives(String userAddress) async {
    final http.Response _serverResponse = await client.get('/users/$userAddress/perspectives');
    final List<Map<String, dynamic>> items = JuntoHttp.handleResponse(_serverResponse);
    return items.map(
      (Map<String, dynamic> data) => CentralizedPerspective.fromMap(data),
    );
  }

  @override
  Future<UserProfile> createPerspectiveUserEntry(
    String userAddress,
    String perspectiveAddress,
  ) async {
    final Map<String, dynamic> _postBody = <String, dynamic>{'user_address': userAddress};
    final http.Response _serverResponse = await client.post('/perspectives/$perspectiveAddress/users', body: _postBody);
    final Map<String, dynamic> _decodedResponse = JuntoHttp.handleResponse(_serverResponse);
    return UserProfile.fromMap(_decodedResponse);
  }

  @override
  Future<void> deletePerspectiveUserEntry(
    String userAddress,
    String perspectiveAddress,
  ) async {
    final http.Response _serverResponse = await client.delete('/perspectives/$perspectiveAddress/users');
    JuntoHttp.handleResponse(_serverResponse);
  }

  @override
  Future<List<UserProfile>> getPerspectiveUsers(
    String perspectiveAddress,
  ) async {
    final http.Response _serverResponse = await client.get('/perspectives/$perspectiveAddress/users');
    final List<dynamic> items = json.decode(_serverResponse.body);
    return items
        .map(
          (dynamic data) => UserProfile.fromMap(data),
        )
        .toList();
  }

  /// Private function which returns the correct query param for the given
  /// [QueryType]
  Map<String, dynamic> _buildQueryParam(String param, QueryType queryType) {
    if (queryType == QueryType.address) {
      return <String, String>{
        'address': param,
      };
    } else if (queryType == QueryType.email) {
      return <String, String>{
        'email': param,
      };
    } else {
      return <String, String>{
        'username': param,
      };
    }
  }
}
