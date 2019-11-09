import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';

class UserRepo {
  UserRepo(this._userService);

  final UserService _userService;

  Future<CentralizedPerspective> createPerspective(Perspective perspective) {
    return _userService.createPerspective(perspective);
  }

  Future<UserProfile> addUserToPerspective(
      String perspectiveAddress, List<String> userAddress) {
    return _userService.addUserToPerspective(perspectiveAddress, userAddress);
  }

  Future<UserData> getUser(String userAddress) {
    return _userService.getUser(userAddress);
  }

  Future<UserProfile> queryUser(String param, QueryType queryType) {
    return _userService.queryUser(param, queryType);
  }

  Future<List<CentralizedPerspective>> getUserPerspective(String userAddress) {
    return _userService.getUserPerspective(userAddress);
  }

  Future<UserGroupsResponse> getUserGroups(String userAddress) {
    return _userService.getUserGroups(userAddress);
  }

  Future<List<CentralizedExpressionResponse>> getUsersResonations(
      String userAddress) {
    return _userService.getUsersResonations(userAddress);
  }

  Future<List<CentralizedExpressionResponse>> getUsersExpressions(
    String userAddress,
  ) {
    return _userService.getUsersExpressions(userAddress);
  }

  Future<UserData> readLocalUser() {
    return _userService.readLocalUser();
  }

  Future<List<CentralizedPerspective>> userPerspectives(String userAddress) {
    return _userService.userPerspectives(userAddress);
  }

  Future<UserProfile> createPerspectiveUserEntry(
    String userAddress,
    String perspectiveAddress,
  ) {
    return _userService.createPerspectiveUserEntry(
        userAddress, perspectiveAddress);
  }

  Future<void> deletePerspectiveUserEntry(
    String userAddress,
    String perspectiveAddress,
  ) {
    return _userService.deletePerspectiveUserEntry(
        userAddress, perspectiveAddress);
  }

  Future<List<UserProfile>> getPerspectiveUsers(
    String perspectiveAddress,
  ) {
    return _userService.getPerspectiveUsers(perspectiveAddress);
  }
}
