import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/sphere.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:http/http.dart' as http;

abstract class SpheresProvider with ChangeNotifier {
  List<Sphere> get spheres;

  /// Allows an authenticated user to create a sphere.
  Future<CentralizedSphereResponse> createSphere(CentralizedSphere sphere);

  /// Returns a [Group] for the given address
  Future<Group> getGroup(String groupAddress);

  /// Returns a list of users in a group along with with their permission
  /// level.
  Future<List<Users>> getGroupMembers(String groupAddress);

  /// Adds the given user address to a group
  Future<void> addGroupMember(
      String groupAddress, String userAddress, String perms);

  /// Removes a user from the given group. Sufficient permission is required
  /// to perform this action.
  Future<void> removeGroupMember(String groupAddress, String userAddress);
}

class SphereProviderCentralized with ChangeNotifier implements SpheresProvider {
  @override
  Future<CentralizedSphereResponse> createSphere(
    CentralizedSphere sphere,
  ) async {
    final Map<String, dynamic> _postBody = sphere.toMap();
    final http.Response _serverResponse = await JuntoHttp().postWithoutEncoding(
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
        await JuntoHttp().get('/groups/$groupAddress');
    final Map<String, dynamic> _data =
        JuntoHttp.handleResponse(_serverResponse);
    return Group.fromMap(_data);
  }

  @override
  Future<void> addGroupMember(
    String groupAddress,
    String userAddress,
    String perms,
  ) async {
    final Map<String, String> _postBody = <String, String>{
      'user_address': userAddress,
      'permission_level': perms
    };
    final http.Response _serverResponse = await JuntoHttp().post(
      '/groups/$groupAddress/members',
      body: _postBody,
    );
    JuntoHttp.handleResponse(_serverResponse);
  }

  @override
  Future<void> removeGroupMember(
      String groupAddress, String userAddress) async {
    final Map<String, String> _postBody = <String, String>{
      'user_address': userAddress,
    };
    final http.Response _serverResponse = await JuntoHttp().delete(
      '/groups/$groupAddress/members',
      body: _postBody,
    );
    JuntoHttp.handleResponse(_serverResponse);
  }

  @override
  List<Sphere> get spheres => Sphere.fetchAll();

  @override
  Future<List<Users>> getGroupMembers(String groupAddress) async {
    final http.Response _serverResponse =
        await JuntoHttp().get('/groups/$groupAddress/members');
    final List<Map<String, dynamic>> items =
        JuntoHttp.handleResponse(_serverResponse);
    return items
        .map(
          (Map<String, dynamic> data) => Users.fromJson(data),
        )
        .toList();
  }
}

@Deprecated('This should only be used for testing.')
class MockSphere with ChangeNotifier implements SpheresProvider {
  final List<Sphere> _spheres = Sphere.fetchAll();

  @override
  List<Sphere> get spheres {
    return _spheres;
  }

  @override
  Future<CentralizedSphereResponse> createSphere(CentralizedSphere sphere) {
    throw UnimplementedError();
  }

  @override
  Future<Group> getGroup(String groupAddress) {
    throw UnimplementedError();
  }

  @override
  Future<void> addGroupMember(
    String groupAddress,
    String userAddress,
    String perms,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeGroupMember(String groupAddress, String userAddress) {
    throw UnimplementedError();
  }

  @override
  Future<List<Users>> getGroupMembers(String groupAddress) {
    throw UnimplementedError();
  }
}
