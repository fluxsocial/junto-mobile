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
    this.userService,
    this._notificationRepo,
    this.db,
    this.expressionService,
  );

  final UserService userService;
  final LocalCache db;
  final NotificationRepo _notificationRepo;
  final ExpressionService expressionService;
  QueryResults<ExpressionResponse> cachedDenExpressions;

  // Invite someone to join JUNTO
  Future<void> inviteUser(String email, String name) {
    return userService.inviteUser(email, name);
  }

  // Retrieve date of last invitation sent
  Future<Map<String, dynamic>> lastInviteSent() {
    return userService.lastInviteSent();
  }

  Future<PerspectiveModel> createPerspective(Perspective perspective) {
    assert(perspective.name != null);
    assert(perspective.members != null);
    return userService.createPerspective(perspective);
  }

  Future<void> deletePerspective(
    String perspectiveAddress,
  ) {
    return userService.deletePerspective(perspectiveAddress);
  }

  Future<UserData> getUser(String userAddress) {
    if (userAddress == null) {
      logger.logError("Null User Address");
    }
    return userService.getUser(userAddress);
  }

  Future<UserProfile> queryUser(String param, QueryType queryType) {
    return userService.queryUser(param, queryType);
  }

  Future<List<PerspectiveModel>> getUserPerspective(String userAddress) async {
    if (await DataConnectionChecker().hasConnection) {
      final results = await userService.getUserPerspective(userAddress);
      db.insertPerspectives(results);
      return results;
    }
    return await db.retrievePerspective();
  }

  Future<List<ExpressionResponse>> getUsersResonations(String userAddress) {
    return userService.getUsersResonations(userAddress);
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
      cachedDenExpressions = await userService.getUsersExpressions(
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
    final results = await userService.userPerspectives(userAddress);
    db.insertPerspectives(results);
    return results;
  }

  Future<UserProfile> createPerspectiveUserEntry(
    String userAddress,
    String perspectiveAddress,
  ) {
    return userService.createPerspectiveUserEntry(
        userAddress, perspectiveAddress);
  }

  Future<void> addUsersToPerspective(
      String perspectiveAddress, List<String> userAddresses) {
    return userService.addUsersToPerspective(perspectiveAddress, userAddresses);
  }

  Future<void> deleteUsersFromPerspective(
    List<Map<String, String>> userAddresses,
    String perspectiveAddress,
  ) {
    return userService.deleteUsersFromPerspective(
        userAddresses, perspectiveAddress);
  }

  Future<List<UserProfile>> getPerspectiveUsers(
    String perspectiveAddress,
  ) {
    return userService.getPerspectiveUsers(perspectiveAddress);
  }

  Future<void> connectUser(String userAddress) {
    return userService.connectUser(userAddress);
  }

  Future<Map<String, dynamic>> userRelations() {
    return userService.userRelations();
  }

  Future<List<UserProfile>> connectedUsers(String userAddress) {
    return userService.connectedUsers(userAddress);
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
    return userService.removeUserConnection(userAddress);
  }

  Future<void> respondToConnection(String userAddress, bool response) {
    return userService.respondToConnection(userAddress, response);
  }

  Future<Map<String, dynamic>> isRelated(
      String userAddress, String targetAddress) {
    return userService.isRelated(userAddress, targetAddress);
  }

  Future<bool> isConnected(String userAddress, String targetAddress) {
    return userService.isConnectedUser(userAddress, targetAddress);
  }

  Future<bool> isFollowing(String userAddress, String targetAddress) {
    return userService.isFollowingUser(userAddress, targetAddress);
  }

  Future<UserProfile> updateUser(
      Map<String, dynamic> user, String userAddress) async {
    final result = await userService.updateUser(user, userAddress);
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
        await expressionService.createPhoto(false, '.png', profilePicture);

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
      userService.getFollowers(userAddress);

  Future<PerspectiveModel> updatePerspective(
          String perspectiveAddress, Map<String, String> perspectiveBody) =>
      userService.updatePerspective(perspectiveAddress, perspectiveBody);

  Future<bool> usernameAvailable(String username) async {
    try {
      logger.logDebug('Checking if username available in cognito pool');
      final verified = await userService.cognitoValidate(username);
      if (verified == true) {
        logger.logDebug('Previous not-verified account had to be removed');
      }

      final result = await userService.validateUsername(username);
      if (result != null) {
        return result.error == null && result.validUsername != false;
      }
      return false;
    } catch (e, s) {
      logger.logException(e, s);
    }
    return false;
  }

  Future<bool> emailAvailable(String email, String username) async {
    try {
      final result = await userService.validateUser(email, username);
      if (result != null) {
        return result.error == null && result.validEmail != false;
      }
      return false;
    } catch (e, s) {
      logger.logException(e, s);
    }
    return false;
  }

  Future<void> deleteUserAccount(String userAddress) {
    if (userAddress != null && userAddress.isNotEmpty) {
      return userService.deleteUser(userAddress);
    } else {
      throw JuntoException("Please ensure password is not empty", 404);
    }
  }

  Future<UserData> sendMetadataPostRegistration(
      UserRegistrationDetails details) async {
    return userService.sendMetadataPostRegistration(details);
  }
}
