import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/models/pack.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:junto_beta_mobile/utils/utils.dart';

/// Interface describing the functions and responsibilities of Pack provider.
/// Please see [PacksProviderImpl] for implementation.
abstract class PacksProvider {
  /// Returns mock list of packs.
  List<Pack> get packs;

  /// Adds a member to a pack.
  Future<String> addMemberToPack(String usernameAddress);

  /// Adds the user address provided to the group passed.
  Future<void> addMemberToGroup(String usernameAddress, String groupAddress);

  /// Removes a member from the given group.
  Future<String> removeGroupMember(String userAddress, String groupAddress);

  /// Returns a boolean indicating whether the user is a member of the given
  /// group.
  Future<bool> isGroupMember(String userAddress, String groupAddress);

  /// Returns a boolean indicating whether the user is the owner of the given
  /// group.
  Future<bool> isGroupOwner(String userAddress, String groupAddress);

  /// Returns a list [Username] of members in the given group.
  /// ```
  ///{ "members": [{"address": "address of user username", "entry": {"username": "username of user"}} ] }
  ///  ```
  Future<List<Username>> getGroupMembers(String groupAddress);

  /// Gets the user created packs.
  /// Result a List of [PackResponse]
  /// Map data contains:
  /// ```
  ///  {"address": "pack address", "entry": {"name": "pack name", "owner": "user address", "privacy": "Shared"}}
  ///  ```
  Future<List<PackResponse>> getUserPacks(String userAddress);

  /// Gets the packs the user is apart of.
  /// Result a List of [PackResponse]
  /// Map data contains:
  /// ```
  /// [
  //{"address": "pack address", "entry": {"name": "pack name", "owner": "user address", "privacy": "Shared"}},
  //            ...
  //]
  // ```
  Future<List<PackResponse>> getUserMemberPack(String userAddress);
}

class PacksProviderImpl implements PacksProvider {
  final List<Pack> _packs = Pack.fetchAll();

  @override
  List<Pack> get packs {
    return _packs;
  }

  @override
  Future<void> addMemberToGroup(
      String usernameAddress, String groupAddress) async {
    assert(usernameAddress.isNotEmpty && groupAddress.isNotEmpty);
    final Map<String, dynamic> holoBody = JuntoHttp.holobody(
      'add_member_to_group',
      'group',
      <String, String>{
        'username_address': usernameAddress,
        'group': groupAddress
      },
    );
    final http.Response serverResponse = await JuntoHttp().post(
      '/holochain',
      body: holoBody,
    );
    final Map<String, dynamic> mapResponse =
        JuntoHttp.handleResponse(serverResponse);
    return mapResponse['message'];
  }

  @override
  Future<List<Username>> getGroupMembers(String groupAddress) async {
    final Map<String, dynamic> _body = JuntoHttp.holobody(
      'get_group_members',
      'group',
      <String, String>{
        'group': groupAddress,
      },
    );

    try {
      final http.Response serverResponse =
          await JuntoHttp().post('/holochain', body: _body);
      final Map<String, dynamic> mapResponse =
          JuntoHttp.handleResponse(serverResponse);
      if (mapResponse['members'] is List) {
        return mapResponse['members']
            .map((dynamic data) => Username.fromMap(data))
            .toList(growable: false);
      }
    } catch (error) {
      debugPrint('Get pack members error $error');
      rethrow;
    }
    return null;
  }

  @override
  Future<String> addMemberToPack(String usernameAddress) async {
    final Map<String, dynamic> _body = JuntoHttp.holobody(
      'add_pack_member',
      'group',
      <String, String>{
        'username_address': usernameAddress,
      },
    );

    try {
      final http.Response serverResponse =
          await JuntoHttp().post('/holochain', body: _body);
      final Map<String, dynamic> mapResponse =
          JuntoHttp.handleResponse(serverResponse);
      if (mapResponse['message']) {
        return mapResponse['message'];
      }
    } catch (error) {
      return error.toString();
    }
    return null;
  }

  @override
  Future<List<PackResponse>> getUserMemberPack(String userAddress) async {
    final Map<String, dynamic> _body = JuntoHttp.holobody(
      'get_user_member_packs',
      'group',
      <String, String>{
        'username_address': userAddress,
      },
    );

    try {
      final http.Response serverResponse =
          await JuntoHttp().post('/holochain', body: _body);
      final dynamic mapResponse = JuntoHttp.handleResponse(serverResponse);
      if (mapResponse is List) {
        return mapResponse
            .map((dynamic data) => PackResponse.fromMap(data))
            .toList(growable: false);
      }
    } catch (error) {
      debugPrint('Get pack members error $error');
      rethrow;
    }
    return null;
  }

  @override
  Future<List<PackResponse>> getUserPacks(String userAddress) async {
    final Map<String, dynamic> _body = JuntoHttp.holobody(
      'get_user_member_packs',
      'group',
      <String, String>{
        'username_address': userAddress,
      },
    );

    try {
      final http.Response serverResponse =
          await JuntoHttp().post('/holochain', body: _body);
      print('Packs Provider body ${serverResponse.body}');
      final Map<String, dynamic> responseBody =
          deserializeHoloJson(serverResponse.body);
      if (responseBody['result']['Ok'] is List) {
        final List<PackResponse> _results = <PackResponse>[];
//        responseBody['result']['Ok']?.forEach((dynamic data) {
//          _results.add(PackResponse.fromMap(data));
//        }).toList(growable: false);
//        return _results;
      print(responseBody['result']['Ok']);
      }
    } catch (error) {
      debugPrint('Get pack members error $error');
    }
    return null;
  }

  @override
  Future<bool> isGroupMember(String userAddress, String groupAddress) async {
    final Map<String, dynamic> _body = JuntoHttp.holobody(
      'is_group_member',
      'group',
      <String, String>{
        'username_address': userAddress,
        'group': groupAddress,
      },
    );
    try {
      final http.Response serverResponse =
          await JuntoHttp().post('/holochain', body: _body);
      final String parsedResponse = JuntoHttp.handleResponse(serverResponse);
      return parsedResponse == 'true';
    } catch (error) {
      debugPrint('Error in isGroupMember $error');
      rethrow;
    }
  }

  @override
  Future<bool> isGroupOwner(String userAddress, String groupAddress) async {
    final Map<String, dynamic> _body = JuntoHttp.holobody(
      'is_group_owner',
      'group',
      <String, String>{
        'username_address': userAddress,
        'group': groupAddress,
      },
    );
    try {
      final http.Response serverResponse =
          await JuntoHttp().post('/holochain', body: _body);
      final String parsedResponse = JuntoHttp.handleResponse(serverResponse);
      return parsedResponse == 'true';
    } catch (error) {
      debugPrint('Error in isGroupOwner $error');
      rethrow;
    }
  }

  @override
  Future<String> removeGroupMember(
    String userAddress,
    String groupAddress,
  ) async {
    final Map<String, dynamic> _body = JuntoHttp.holobody(
      'remove_group_member',
      'group',
      <String, String>{
        'username_address': userAddress,
        'group': groupAddress,
      },
    );
    try {
      final http.Response serverResponse =
          await JuntoHttp().post('/holochain', body: _body);
      final Map<String, dynamic> parsedResponse =
          JuntoHttp.handleResponse(serverResponse);
      if (parsedResponse['message']) {
        return parsedResponse['message'];
      }
      return 'Unable to remove member';
    } catch (error) {
      debugPrint('Error in isGroupOwner $error');
      rethrow;
    }
  }
}
