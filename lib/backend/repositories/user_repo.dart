import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/hive_keys.dart';
import 'package:junto_beta_mobile/models/models.dart';

class UserRepo {
  UserRepo(this._userService, this._notificationRepo, this.db);

  final UserService _userService;
  final LocalCache db;
  final NotificationRepo _notificationRepo;
  QueryResults<ExpressionResponse> cachedDenExpressions;

  Future<PerspectiveModel> createPerspective(Perspective perspective) {
    assert(perspective.name != null);
    assert(perspective.members != null);
    return _userService.createPerspective(perspective);
  }

  Future<void> deletePerspective(
    String perspectiveAddress,
  ) {
    return _userService.deletePerspective(perspectiveAddress);
  }

  Future<UserData> getUser(String userAddress) {
    return _userService.getUser(userAddress);
  }

  Future<UserProfile> queryUser(String param, QueryType queryType) {
    return _userService.queryUser(param, queryType);
  }

  Future<List<PerspectiveModel>> getUserPerspective(String userAddress) {
    return _userService.getUserPerspective(userAddress);
  }

  Future<List<ExpressionResponse>> getUsersResonations(String userAddress) {
    return _userService.getUsersResonations(userAddress);
  }

  Future<QueryResults<ExpressionResponse>> getUsersExpressions(
    String userAddress,
    int paginationPos,
    String lastTimestamp,
  ) async {
    assert(userAddress != null && userAddress.isNotEmpty);
    if (await DataConnectionChecker().hasConnection) {
      cachedDenExpressions = await _userService.getUsersExpressions(
        userAddress,
        paginationPos,
        lastTimestamp,
      );
      await db.insertExpressions(
          cachedDenExpressions.results, DBBoxes.denExpressions);
      return cachedDenExpressions;
    }
    final cachedResult = await db.retrieveExpressions(
      DBBoxes.denExpressions,
    );
    return QueryResults(
      lastTimestamp: cachedDenExpressions?.lastTimestamp,
      results: cachedResult,
    );
  }

  Future<UserData> readLocalUser() {
    return _userService.readLocalUser();
  }

  Future<List<PerspectiveModel>> userPerspectives(String userAddress) {
    return _userService.userPerspectives(userAddress);
  }

  Future<UserProfile> createPerspectiveUserEntry(
    String userAddress,
    String perspectiveAddress,
  ) {
    return _userService.createPerspectiveUserEntry(
        userAddress, perspectiveAddress);
  }

  Future<void> addUsersToPerspective(
      String perspectiveAddress, List<String> userAddresses) {
    return _userService.addUsersToPerspective(
        perspectiveAddress, userAddresses);
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

  Future<Map<String, dynamic>> userRelations() {
    return _userService.userRelations();
  }

  Future<List<UserProfile>> connectedUsers(String userAddress) {
    return _userService.connectedUsers(userAddress);
  }

  Future<List<UserProfile>> pendingConnections(String userAddress) async {
    final result =
        await _notificationRepo.getJuntoNotifications(connectionRequests: true);
    if (result.wasSuccessful) {
      final notifications = result.results
          .where((element) =>
              element.notificationType ==
              NotificationType.ConnectionNotification)
          .toList();
      final users = notifications.map((e) => e.user).toList();
      return users;
    } else {
      return <UserProfile>[];
    }
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

  Future<UserProfile> updateUser(
      Map<String, dynamic> user, String userAddress) async {
    final result = await _userService.updateUser(user, userAddress);
    final box = await Hive.openLazyBox(HiveBoxes.kAppBox);
    box.put(HiveKeys.kUserData, jsonEncode(result));
    final Map<String, dynamic> decodedUserData =
        jsonDecode(await box.get(HiveKeys.kUserData));
    decodedUserData['user'] = result;
    box.delete(HiveKeys.kUserData);
    box.put(HiveKeys.kUserData, jsonEncode(decodedUserData));
    return UserProfile.fromMap(result);
  }

  Future<List<UserProfile>> getFollowers(String userAddress) =>
      _userService.getFollowers(userAddress);

  Future<PerspectiveModel> updatePerspective(
          String perspectiveAddress, Map<String, String> perspectiveBody) =>
      _userService.updatePerspective(perspectiveAddress, perspectiveBody);
}
