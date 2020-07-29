import 'dart:convert';
import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/hive_keys.dart';
import 'package:junto_beta_mobile/models/auth_result.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';

class UserRepo {
  UserRepo(
    this._userService,
    this._notificationRepo,
    this.db,
    this._expressionService,
  );

  final UserService _userService;
  final LocalCache db;
  final NotificationRepo _notificationRepo;
  final ExpressionService _expressionService;
  QueryResults<ExpressionResponse> cachedDenExpressions;

  // Invite someone to join JUNTO
  Future<int> inviteUser(String email, String name) {
    return _userService.inviteUser(email, name);
  }

  // Retrieve date of last invitation sent
  Future<void> lastInviteUser() {}

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

  Future<List<PerspectiveModel>> getUserPerspective(String userAddress) async {
    if (await DataConnectionChecker().hasConnection) {
      final results = await _userService.getUserPerspective(userAddress);
      db.insertPerspectives(results);
      return results;
    }
    return await db.retrievePerspective();
  }

  Future<List<ExpressionResponse>> getUsersResonations(String userAddress) {
    return _userService.getUsersResonations(userAddress);
  }

  Future<QueryResults<ExpressionResponse>> getUsersExpressions(
    String userAddress,
    int paginationPos,
    String lastTimestamp,
    bool rootExpressions,
    bool subExpressions,
    bool communityFeedback,
  ) async {
    assert(userAddress != null && userAddress.isNotEmpty);
    DBBoxes cacheBox;

    if (await DataConnectionChecker().hasConnection) {
      cachedDenExpressions = await _userService.getUsersExpressions(
        userAddress,
        paginationPos,
        lastTimestamp,
        rootExpressions,
        subExpressions,
        communityFeedback,
      );

      if (rootExpressions) {
        cacheBox = DBBoxes.denRootExpressions;
      } else if (subExpressions) {
        cacheBox = DBBoxes.denSubExpressions;
      }
      await db.insertExpressions(cachedDenExpressions.results, cacheBox);
      return cachedDenExpressions;
    }

    final cachedResult = await db.retrieveExpressions(
      cacheBox,
    );
    return QueryResults(
      lastTimestamp: cachedDenExpressions?.lastTimestamp,
      results: cachedResult,
    );
  }

  Future<List<PerspectiveModel>> userPerspectives(String userAddress) async {
    final results = await _userService.userPerspectives(userAddress);
    db.insertPerspectives(results);
    return results;
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
    //TODO: pending connections through notifications can be replaced by call to /users/self/relations
    // https://github.com/juntofoundation/Junto-REST-API/blob/cognito-implementation/docs/user.md
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
    final box = await Hive.box(HiveBoxes.kAppBox);
    box.put(HiveKeys.kUserData, jsonEncode(result));
    final Map<String, dynamic> decodedUserData =
        jsonDecode(await box.get(HiveKeys.kUserData));
    decodedUserData['user'] = result;
    box.delete(HiveKeys.kUserData);
    box.put(HiveKeys.kUserData, jsonEncode(decodedUserData));
    return UserProfile.fromJson(result);
  }

  Future<UserProfile> updateProfilePicture(
      String userAddress, File profilePicture) async {
    final key =
        await _expressionService.createPhoto(false, '.png', profilePicture);

    final _profilePictureKeys = <String, dynamic>{
      'profile_picture': <Map<String, dynamic>>[
        <String, dynamic>{'index': 0, 'key': key},
      ]
    };
    // update user with profile photos
    return await updateUser(
      _profilePictureKeys,
      userAddress,
    );
  }

  Future<List<UserProfile>> getFollowers(String userAddress) =>
      _userService.getFollowers(userAddress);

  Future<PerspectiveModel> updatePerspective(
          String perspectiveAddress, Map<String, String> perspectiveBody) =>
      _userService.updatePerspective(perspectiveAddress, perspectiveBody);

  Future<bool> usernameAvailable(String username) async {
    try {
      logger.logDebug('Checking if username available in cognito pool');
      final verified = await _userService.cognitoValidate(username);
      if (verified == true) {
        logger.logDebug('Previous not-verified account had to be removed');
      }

      final result = await _userService.validateUsername(username);
      if (result != null) {
        return result.error == null && result.validUsername != false;
      }
      return false;
    } catch (e) {
      logger.logException(e);
    }
    return false;
  }

  Future<bool> emailAvailable(String email, String username) async {
    try {
      final result = await _userService.validateUser(email, username);
      if (result != null) {
        return result.error == null && result.validEmail != false;
      }
      return false;
    } catch (e) {
      logger.logException(e);
    }
    return false;
  }

  Future<void> deleteUserAccount(String userAddress) {
    if (userAddress != null && userAddress.isNotEmpty) {
      return _userService.deleteUser(userAddress);
    } else {
      throw JuntoException("Please ensure password is not empty", 404);
    }
  }

  Future<UserData> sendMetadataPostRegistration(
      UserRegistrationDetails details) async {
    return _userService.sendMetadataPostRegistration(details);
  }
}
