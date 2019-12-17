import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/mock/mock_data.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

class MockUserService implements UserService {
  @override
  Future<UserProfile> addUserToPerspective(
      String perspectiveAddress, List<String> userAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    throw kUserProfile;
  }

  @override
  Future<CentralizedPerspective> createPerspective(
      Perspective perspective) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kPerspectives.first;
  }

  @override
  Future<UserProfile> createPerspectiveUserEntry(
      String userAddress, String perspectiveAddress) async {
    throw kGroupUsers[1].user;
  }

  @override
  Future<void> deletePerspectiveUserEntry(
      String userAddress, String perspectiveAddress) async {
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
    throw UnimplementedError();
  }

  @override
  Future<UserGroupsResponse> getUserGroups(String userAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    throw UnimplementedError();
  }

  @override
  Future<List<CentralizedPerspective>> getUserPerspective(
      String userAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kPerspectives;
  }

  @override
  Future<List<CentralizedExpressionResponse>> getUsersExpressions(
      String userAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kSampleExpressions;
  }

  @override
  Future<List<CentralizedExpressionResponse>> getUsersResonations(
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
    await Future<void>.delayed(const Duration(milliseconds: 500));
    throw UnimplementedError();
  }

  @override
  Future<List<CentralizedPerspective>> userPerspectives(
      String userAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kPerspectives;
  }
}
