import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/backend/mock/mock_data.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/models.dart';

@visibleForTesting
class MockSphere with ChangeNotifier implements GroupService {
  final List<Sphere> _spheres = Sphere.fetchAll();

  @override
  List<Sphere> get spheres {
    return _spheres;
  }

  @override
  Future<CentralizedSphereResponse> createSphere(
      CentralizedSphere sphere) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return CentralizedSphereResponse(
      creator: kUserProfile.address,
      groupData: null,
      privacy: null,
      users: <Users>[],
      createdAt: null,
      address: null,
      groupType: null,
    );
  }

  @override
  Future<Group> getGroup(String groupAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kGroups.first;
  }

  @override
  Future<void> addGroupMember(
    String groupAddress,
    List<Map<String, dynamic>> users,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> removeGroupMember(
      String groupAddress, String userAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<Users>> getGroupMembers(String groupAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kGroupUsers;
  }

  @override
  Future<List<CentralizedExpressionResponse>> getGroupExpressions(
      String groupAddress, GroupExpressionQueryParams params) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kSampleExpressions;
  }

  @override
  Future<Group> updateGroup(Group group) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kGroups.first;
  }
}
