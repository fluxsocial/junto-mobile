import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/backend/mock/mock_data.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';

@visibleForTesting
class MockSphere with ChangeNotifier implements GroupService {
  final List<Sphere> _spheres = Sphere.fetchAll();

  @override
  List<Sphere> get spheres {
    return _spheres;
  }

  @override
  Future<SphereResponse> createSphere(SphereModel sphere) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return SphereResponse(
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
  Future<void> deleteGroup(String groupAddress) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    );
    return;
  }

  @override
  Future<Group> getGroup(String groupAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kGroups.first;
  }

  @override
  Future<Map<String, dynamic>> getRelationToGroup(
      String groupAddress, String userAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return {};
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
  Future<QueryResults<Users>> getGroupMembers(
      String groupAddress, ExpressionQueryParams params) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return QueryResults(results: kGroupUsers, lastTimestamp: '');
  }

  @override
  Future<List<ExpressionResponse>> getGroupExpressions(
      String groupAddress, GroupExpressionQueryParams params) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kSampleExpressions;
  }

  @override
  Future<Group> updateGroup(Group group) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kGroups.first;
  }

  @override
  Future<void> respondToGroupRequest(
    String groupAddress,
    bool decision,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}
