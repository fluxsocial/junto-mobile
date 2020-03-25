import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/mock/mock_data.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

class MockUserService implements UserService {
  @override
  Future<PerspectiveModel> createPerspective(Perspective perspective) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kPerspectives.first;
  }

  @override
  Future<void> deletePerspective(String perspective) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return;
  }

  @override
  Future<UserProfile> createPerspectiveUserEntry(
      String userAddress, String perspectiveAddress) async {
    throw kGroupUsers[1].user;
  }

  @override
  Future<void> addUsersToPerspective(
      String perspectiveAddress, List<String> userAddresses) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    throw kUserProfile;
  }

  @override
  Future<void> deleteUsersFromPerspective(
      List<Map<String, String>> userAddresses,
      String perspectiveAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<UserProfile>> getPerspectiveUsers(
      String perspectiveAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kUsers;
  }

  @override
  Future<UserData> getUser(String userAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kUserData;
  }

  @override
  Future<UserGroupsResponse> getUserGroups(String userAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    throw UnimplementedError();
  }

  @override
  Future<List<PerspectiveModel>> getUserPerspective(String userAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kPerspectives;
  }

  @override
  Future<QueryResults<ExpressionResponse>> getUsersExpressions(
      String userAddress, int paginationPos, String lastTimestamp) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return QueryResults(results: kSampleExpressions, lastTimestamp: '');
  }

  @override
  Future<List<ExpressionResponse>> getUsersResonations(
      String userAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kSampleExpressions.reversed.toList();
  }

  @override
  Future<UserProfile> queryUser(String param, QueryType queryType) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kUsers.last;
  }

  @override
  Future<UserData> readLocalUser() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return kUserData;
  }

  @override
  Future<List<PerspectiveModel>> userPerspectives(String userAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kPerspectives;
  }

  @override
  Future<void> connectUser(String userAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<Map<String, dynamic>> userRelations() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return <String, dynamic>{};
  }

  @override
  Future<List<UserProfile>> connectedUsers(String userAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kUsers;
  }

  Future<List<UserProfile>> pendingConnections(String userAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kUsers;
  }

  @override
  Future<void> removeUserConnection(String userAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> respondToConnection(String userAddress, bool response) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<Map<String, dynamic>> isRelated(
      String userAddress, String targetAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return <String, dynamic>{};
  }

  @override
  Future<bool> isConnectedUser(String userAddress, String targetAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return false;
  }

  @override
  Future<bool> isFollowingUser(String userAddress, String targetAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return true;
  }

  @override
  Future<Map<String, dynamic>> updateUser(
      Map<String, dynamic> profile, String userAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return <String, dynamic>{};
  }

  @override
  Future<List<UserProfile>> getFollowers(String userAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return List<UserProfile>.generate(10, (int index) => kUserProfile);
  }

  @override
  Future<PerspectiveModel> updatePerspective(
    String perspectiveAddress,
    Map<String, String> perspectiveBody,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kPerspectives.first;
  }
}
