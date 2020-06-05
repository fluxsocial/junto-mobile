import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/hive_keys.dart';
import 'package:junto_beta_mobile/models/auth_result.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:meta/meta.dart';

@immutable
class UserServiceCentralized implements UserService {
  const UserServiceCentralized(this.client);

  final JuntoHttp client;

  /// Creates a [Perspective] on the server. Function takes a single argument.
  @override
  Future<PerspectiveModel> createPerspective(Perspective perspective) async {
    final Map<String, dynamic> _postBody = <String, dynamic>{
      'name': perspective.name,
      'members': perspective.members,
      'about': perspective.about,
    };
    final http.Response _serverResponse = await client.postWithoutEncoding(
      '/perspectives',
      body: _postBody,
    );

    final Map<String, dynamic> _body =
        JuntoHttp.handleResponse(_serverResponse);
    return PerspectiveModel.fromMap(_body);
  }

  @override
  Future<void> deletePerspective(
    String perspectiveAddress,
  ) async {
    final http.Response _serverResponse =
        await client.delete('/perspectives/$perspectiveAddress');
    JuntoHttp.handleResponse(_serverResponse);
  }

  @override
  Future<UserData> getUser(String userAddress) async {
    logger.logDebug(userAddress);
    final http.Response _serverResponse =
        await client.get('/users/$userAddress');

    final Map<String, dynamic> _resultMap =
        JuntoHttp.handleResponse(_serverResponse);
    final UserData _userData = UserData.fromMap(_resultMap);
    return _userData;
  }

  @override
  Future<UserProfile> queryUser(String param, QueryType queryType) async {
    final box = await Hive.box(HiveBoxes.kAppBox);
    final authKey = await box.get("auth");
    final Uri _uri = Uri.http(
      END_POINT,
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
      throw JuntoException(
          'Unable to retrive user profile', _serverResponse.statusCode);
    }
    throw JuntoException('Forbidden, please log out and log back in',
        _serverResponse.statusCode);
  }

  @override
  Future<List<PerspectiveModel>> getUserPerspective(String userAddress) async {
    final http.Response response =
        await client.get('/users/$userAddress/perspectives');
    final List<dynamic> _listData = JuntoHttp.handleResponse(response);
    final List<PerspectiveModel> _results = _listData
        .map((dynamic data) => PerspectiveModel.fromMap(data))
        .toList(growable: false);
    return _results;
  }

  @override
  Future<UserGroupsResponse> getUserGroups(String userAddress) async {
    final http.Response response = await client.get(
      '/users/$userAddress/groups',
    );

    final Map<String, dynamic> _responseMap =
        JuntoHttp.handleResponse(response);
    return UserGroupsResponse.fromMap(_responseMap);
  }

  @override
  Future<List<ExpressionResponse>> getUsersResonations(
    String userAddress,
  ) async {
    final http.Response response =
        await client.get('/users/$userAddress/resonations');
    final List<dynamic> _responseMap = JuntoHttp.handleResponse(response);
    return _responseMap
        .map(
          (dynamic data) => ExpressionResponse.withCommentsAndResonations(data),
        )
        .toList();
  }

  @override
  Future<QueryResults<ExpressionResponse>> getUsersExpressions(
    String userAddress,
    int paginationPos,
    String lastTimestamp,
  ) async {
    final parms = <String, String>{
      'root_expressions': 'true',
      'sub_expressions': 'false',
      'pagination_position': '$paginationPos',
    };
    if (lastTimestamp != null && lastTimestamp.isNotEmpty) {
      parms.putIfAbsent('last_timestamp', () => lastTimestamp);
    }
    final http.Response response =
        await client.get('/users/$userAddress/expressions', queryParams: parms);

    final Map<String, dynamic> _responseMap =
        JuntoHttp.handleResponse(response);
    return QueryResults(
      lastTimestamp: _responseMap['root_expressions']['last_timestamp'],
      results: <ExpressionResponse>[
        for (dynamic data in _responseMap['root_expressions']['results'])
          ExpressionResponse.fromMap(data)
      ],
    );
  }

  @override
  Future<List<PerspectiveModel>> userPerspectives(String userAddress) async {
    final http.Response _serverResponse =
        await client.get('/users/$userAddress/perspectives');
    final List<Map<String, dynamic>> items =
        JuntoHttp.handleResponse(_serverResponse);
    return items.map(
      (Map<String, dynamic> data) => PerspectiveModel.fromMap(data),
    );
  }

  @override
  Future<UserProfile> createPerspectiveUserEntry(
    String userAddress,
    String perspectiveAddress,
  ) async {
    final Map<String, dynamic> _postBody = <String, dynamic>{
      'user_address': userAddress
    };
    final http.Response _serverResponse = await client.postWithoutEncoding(
        '/perspectives/$perspectiveAddress/users',
        body: _postBody);
    final Map<String, dynamic> _decodedResponse =
        JuntoHttp.handleResponse(_serverResponse);
    return UserProfile.fromMap(_decodedResponse);
  }

  @override
  Future<void> addUsersToPerspective(
      String perspectiveAddress, List<String> userAddresses) async {
    final List<Map<String, String>> users = <Map<String, String>>[];
    for (final String user in userAddresses) {
      users.add(<String, String>{'user_address': user});
    }
    final http.Response _serverResponse = await client.postWithoutEncoding(
      '/perspectives/$perspectiveAddress/users',
      body: users,
    );
    JuntoHttp.handleResponse(_serverResponse);
  }

  @override
  Future<void> deleteUsersFromPerspective(
    List<Map<String, String>> userAddresses,
    String perspectiveAddress,
  ) async {
    final http.Response _serverResponse = await client
        .delete('/perspectives/$perspectiveAddress/users', body: userAddresses);
    JuntoHttp.handleResponse(_serverResponse);
  }

  @override
  Future<List<UserProfile>> getPerspectiveUsers(
    String perspectiveAddress,
  ) async {
    final http.Response _serverResponse =
        await client.get('/perspectives/$perspectiveAddress/users');
    final List<dynamic> _results = JuntoHttp.handleResponse(_serverResponse);
    return <UserProfile>[
      for (dynamic data in _results) UserProfile.fromMap(data)
    ];
  }

  @override
  Future<void> connectUser(String userAddress) async {
    final http.Response _serverResponse = await client.postWithoutEncoding(
      '/users/$userAddress/connect',
    );
    JuntoHttp.handleResponse(_serverResponse);
  }

  @override
  Future<void> removeUserConnection(String userAddress) async {
    final http.Response _serverResponse = await client.delete(
      '/users/$userAddress/connect',
    );
    logger.logDebug(_serverResponse.statusCode.toString());
    JuntoHttp.handleResponse(_serverResponse);
  }

  @override
  Future<Map<String, dynamic>> userRelations() async {
    final http.Response _serverResponse = await client.get(
      '/users/self/relations',
    );

    // handle response from server
    final Map<String, dynamic> _results =
        await JuntoHttp.handleResponse(_serverResponse);

    // set each relationship key into its own variable
    final Map<String, dynamic> _following = _results['following'];
    final Map<String, dynamic> _followers = _results['followers'];
    final Map<String, dynamic> _connections = _results['connections'];
    final Map<String, dynamic> _pendingConnections =
        _results['pending_connections'];
    final Map<String, dynamic> _pendingPackRequests =
        _results['pending_group_join_requests'];

    // get the list of users for each relationship type
    final List<dynamic> _followingResults = _results['following']['results'];
    final List<dynamic> _followerResults = _results['followers']['results'];
    final List<dynamic> _connectionsResults =
        _results['connections']['results'];
    final List<dynamic> _pendingConnectionsResults =
        _results['pending_connections']['results'];
    final List<dynamic> _pendingPackRequestsResults =
        _results['pending_group_join_requests']['results'];

    // instantiate new variables for list of members; to be used after converting
    // list of users above to UserProfile
    final List<UserProfile> _connectionsMembers = <UserProfile>[];
    final List<UserProfile> _followingMembers = <UserProfile>[];
    final List<UserProfile> _followerMembers = <UserProfile>[];
    final List<UserProfile> _pendingConnectionsMembers = <UserProfile>[];
    final List<UserProfile> _pendingPackRequestsMembers = <UserProfile>[];

    if (_connectionsResults.isNotEmpty) {
      for (final dynamic result in _connectionsResults) {
        _connectionsMembers.add(
          UserProfile.fromMap(result),
        );
      }
    }

    if (_followingResults.isNotEmpty) {
      for (final dynamic result in _followingResults) {
        _followingMembers.add(
          UserProfile.fromMap(result['user']),
        );
      }
    }

    if (_followerResults.isNotEmpty) {
      for (final dynamic result in _followerResults) {
        _followerMembers.add(
          UserProfile.fromMap(result['user']),
        );
      }
    }

    for (final dynamic result in _pendingConnectionsResults) {
      _pendingConnectionsMembers.add(
        UserProfile.fromMap(result),
      );
    }

    if (_pendingPackRequestsResults.isNotEmpty) {
      for (final dynamic result in _pendingPackRequestsResults) {
        if (result['group_type'] == 'Pack') {
          _pendingPackRequestsMembers.add(
            UserProfile.fromMap(result),
          );
        }
      }
    }

    // replace the results (list of users) from the server response with new list of UserProfiles
    _following['results'] = _followingMembers;
    _followers['results'] = _followerMembers;
    _connections['results'] = _connectionsMembers;
    _pendingConnections['results'] = _pendingConnectionsMembers;
    _pendingPackRequests['results'] = _pendingPackRequestsMembers;

    // replace originalrelationship keys with updated versions
    _results['following'] = _following;
    _results['followers'] = _followers;
    _results['connections'] = _connections;
    _results['pending_connections'] = _pendingConnections;
    _results['pending_group_join_requests'] = _pendingPackRequests;

    return _results;
  }

  @override
  Future<List<UserProfile>> connectedUsers(String userAddress) async {
    final http.Response _serverResponse = await client.get(
      '/users/$userAddress/connections',
    );
    final List<dynamic> _results =
        await JuntoHttp.handleResponse(_serverResponse);

    final List<UserProfile> _resultsList = <UserProfile>[];

    // ignore: avoid_function_literals_in_foreach_calls
    _results.forEach((dynamic result) {
      _resultsList.add(
        UserProfile(
          address: result['user']['address'],
          bio: result['user']['bio'],
          username: result['user']['username'],
          name: result['user']['name'],
          profilePicture: <String>[],
          backgroundPhoto: result['user']['background_photo'],
          gender: List<String>.from(result['user']['gender']),
          location: List<String>.from(result['user']['location']),
          verified: true,
          website: List<String>.from(result['user']['website']),
        ),
      );
    });

    return _resultsList;
  }

  @override
  Future<void> respondToConnection(String userAddress, bool response) async {
    final http.Response _serverResponse = await client.postWithoutEncoding(
      '/users/$userAddress/connect/respond',
      body: <String, dynamic>{
        'status': response,
      },
    );

    JuntoHttp.handleResponse(_serverResponse);
  }

  @override
  Future<Map<String, dynamic>> updateUser(
      Map<String, dynamic> body, String userAddress) async {
    // make request to api with encoded json body
    final http.Response _serverResponse =
        await client.patch('/users/$userAddress', body: body);

    // handle response
    final Map<String, dynamic> _data =
        JuntoHttp.handleResponse(_serverResponse);

    return _data;
  }

  @override
  Future<List<UserProfile>> getFollowers(String userAddress) async {
    final http.Response _serverResponse = await client.get(
      '/users/$userAddress/followers',
      queryParams: <String, String>{
        'pagination_position': '0',
      },
    );
    final Map<String, dynamic> _data =
        JuntoHttp.handleResponse(_serverResponse);
    return <UserProfile>[
      for (dynamic data in _data['results']) UserProfile.fromMap(data)
    ];
  }

  @override
  Future<PerspectiveModel> updatePerspective(
      String perspectiveAddress, Map<String, String> perspectiveBody) async {
    final http.Response _serverResponse = await client.patch(
      '/perspectives/$perspectiveAddress',
      body: perspectiveBody,
    );
    final Map<String, dynamic> _data =
        JuntoHttp.handleResponse(_serverResponse);
    return PerspectiveModel.fromMap(_data);
  }

  @override
  Future<Map<String, dynamic>> isRelated(
      String userAddress, String targetAddress) async {
    final http.Response _serverResponse = await client.get(
      '/users/$userAddress/related/$targetAddress',
    );
    logger.logInfo(_serverResponse.body);
    final Map<String, dynamic> result =
        JuntoHttp.handleResponse(_serverResponse);

    return result;
  }

  @override
  Future<bool> isConnectedUser(String userAddress, String targetAddress) async {
    final http.Response _serverResponse = await client.get(
      '/users/$userAddress/connected/$targetAddress',
    );
    final bool result = JuntoHttp.handleResponse(_serverResponse) as bool;
    return result;
  }

  @override
  Future<bool> isFollowingUser(String userAddress, String targetAddress) async {
    final http.Response _serverResponse = await client.get(
      '/users/$userAddress/following/$targetAddress',
    );
    final bool result = JuntoHttp.handleResponse(_serverResponse) as bool;
    return result;
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

  @override
  Future<ValidUserModel> validateUser(String email, String username) async {
    final Map<String, dynamic> _postBody = <String, dynamic>{
      if (email != null) 'email': email,
      if (username != null) 'username': username,
    };
    final http.Response _serverResponse = await client.postWithoutEncoding(
      '/users/validate',
      body: _postBody,
      authenticated: false,
    );
    final Map<String, dynamic> _decodedResponse =
        JuntoHttp.handleResponse(_serverResponse);
    return ValidUserModel.fromJson(_decodedResponse);
  }

  @override
  Future<ValidUserModel> validateUsername(String username) async {
    final Map<String, dynamic> _postBody = <String, dynamic>{
      if (username != null) 'username': username,
    };
    final http.Response _serverResponse = await client.postWithoutEncoding(
      '/users/validate/username',
      body: _postBody,
      authenticated: false,
    );
    final Map<String, dynamic> _decodedResponse =
        JuntoHttp.handleResponse(_serverResponse);
    return ValidUserModel.fromJson(_decodedResponse);
  }

  @override
  Future<UserData> sendMetadataPostRegistration(
      UserRegistrationDetails details) async {
    assert(details.name.isNotEmpty);
    assert(details.username.isNotEmpty);
    final Map<String, dynamic> _body = <String, dynamic>{
      'email': details.email,
      'name': details.name,
      'bio': details.bio,
      'username': details.username,
      'website': details.website,
      'gender': details.gender,
      'location': details.location,
      'profile_picture': details.profileImage,
    };

    final http.Response response = await client.postWithoutEncoding(
      '/users',
      body: _body,
    );
    logger.logDebug(response.body);
    final Map<String, dynamic> _responseMap =
        JuntoHttp.handleResponse(response);
    final UserData _userData = UserData.fromMap(_responseMap);
    return _userData;
  }
}
