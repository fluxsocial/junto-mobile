import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';

class UserRepo {
  UserRepo(this._userService);

  final UserService _userService;

  Future<CentralizedPerspective> createPerspective(Perspective perspective) {
    assert(perspective.name != null);
    assert(perspective.members != null);
    return _userService.createPerspective(perspective);
  }

  @override
  Future<void> deletePerspective(
    String perspectiveAddress,
  ) {
    return _userService.deletePerspective(perspectiveAddress);
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
    assert(userAddress != null && userAddress.isNotEmpty);
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

  Future<void> deleteUsersFromPerspective(
    List<Map<String, String>> userAddresses,
    String perspectiveAddress,
  ) {
    return _userService.deleteUsersFromPerspective(
        userAddresses, perspectiveAddress);
  }

  Future<List<UserProfile>> getPerspectiveUsers(
    String perspectiveAddress,
  ) {
    return _userService.getPerspectiveUsers(perspectiveAddress);
  }

  Future<void> connectUser(String userAddress) {
    return _userService.connectUser(userAddress);
  }

  Future userRelations() {
    return _userService.userRelations();
  }

  Future<List<UserProfile>> connectedUsers(String userAddress) {
    return _userService.connectedUsers(userAddress);
  }

  Future<List<UserProfile>> pendingConnections(String userAddress) {
    return _userService.pendingConnections(userAddress);
  }

  Future<void> removeUserConnection(String userAddress) {
    return _userService.removeUserConnection(userAddress);
  }

  Future<void> respondToConnection(String userAddress, bool response) {
    return _userService.respondToConnection(userAddress, response);
  }

  Future<Map<String, dynamic>> isRelated(
      String userAddress, String targetAddress) {
    return _userService.isRelated(userAddress, targetAddress);
  }

  Future<bool> isConnected(String userAddress, String targetAddress) {
    return _userService.isConnectedUser(userAddress, targetAddress);
  }

  Future<bool> isFollowing(String userAddress, String targetAddress) {
    return _userService.isFollowingUser(userAddress, targetAddress);
  }

  Future<Map<String, dynamic>> updateUser(
          Map<String, dynamic> user, String userAddress) =>
      _userService.updateUser(user, userAddress);

  Future<List<UserProfile>> getFollowers(String userAddress) =>
      _userService.getFollowers(userAddress);

  Future<CentralizedPerspective> updatePerspective(
          String perspectiveAddress, Map<String, String> perspectiveBody) =>
      _userService.updatePerspective(perspectiveAddress, perspectiveBody);
}
