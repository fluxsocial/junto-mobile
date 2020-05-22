import 'dart:io';

import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/junto_notification_results.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/notification_query.dart';

abstract class SearchService {
  /// Returns a [QueryResults] contains a list of [UserProfile] matching the [query]
  Future<QueryResults<UserProfile>> searchMembers(
    String query, {
    bool username = false,
    int paginationPosition,
    String lastTimeStamp,
  });

  /// Returns a [QueryResults] contains the names of channels matching the [query]
  Future<QueryResults<Channel>> searchChannel(
    String query, {
    int paginationPosition = 0,
    DateTime lastTimeStamp,
  });

  /// Returns a [QueryResults] contains a list of [Group] matching the [query]
  Future<QueryResults<Group>> searchSphere(
    String query, {
    int paginationPosition = 0,
    DateTime lastTimeStamp,
    bool handle,
  });
}

/// Abstract class which defines the functionality of the Authentication Provider
abstract class AuthenticationService {
  // verifies the email of a user
  Future<Map<String, dynamic>> validateUser({String username, String email});

  // verifies the email of a user
  Future<String> verifyEmail(String email);

  /// Registers a user on the server and creates their profile.
  Future<UserData> registerUser(UserAuthRegistrationDetails details);

  // Request verification code to reset password
  Future<int> requestPasswordReset(String email);

  // Request verification code to reset password
  Future<void> resetPassword(Map<String, dynamic> details);

  /// Authenticates a registered user. Returns the [UserProfile]  for the
  /// given user. Their cookie is stored locally on device and is used for
  /// all future request.
  Future<UserData> loginUser(UserAuthLoginDetails details);

  /// Logs out a user and removes their auth token from the device.
  Future<void> logoutUser();
}

abstract class CollectiveService {
  /// Creates a collection with the given arguments.
  Future<Collective> createCollection(String name, String privacy,
      [String parent]);

  /// Returns the [CollectionResponse] for the given [collectionAddress]
  Future<CollectionResponse> getCollection(String collectionAddress);

  /// Adds the given [expressionAddress] to the collective [collectionAddress]
  Future<void> postCollectiveExpression(
      String collectionAddress, String expressionAddress);
}

/// Interface which defines the roles and functionality of the
/// CollectiveProvider.
abstract class ExpressionService {
  /// Creates an expression on the server.
  /// Method requires [ExpressionModel] as it's only arg.
  Future<ExpressionResponse> createExpression(
    ExpressionModel expression,
  );

  Future<String> createPhoto(bool isPrivate, String fileType, File file);

  Future<String> createAudio(bool isPrivate, AudioFormExpression expression);

  /// Returns a [ExpressionResponse] for the given address.
  Future<ExpressionResponse> getExpression(
    String expressionAddress,
  );

  /// Allows a user to resonate with the given expression.
  /// [expressionAddress] must not be null or empty.
  Future<Resonation> postResonation(
    String expressionAddress,
  );

  /// Allows the user to comment under the supplied expression.
  /// [parentAddress], [type] and [data] must be passed.
  Future<ExpressionResponse> postCommentExpression(
    String parentAddress,
    String type,
    Map<String, dynamic> data,
  );

  /// Returns a list of [UserProfile] for the users who resonated with the
  /// given [expressionAddress].
  Future<List<UserProfile>> getExpressionsResonation(
    String expressionAddress,
  );

  /// Returns a list of [Comment]s for the given [expressionAddress].
  Future<QueryResults<Comment>> getExpressionsComments(
    String expressionAddress,
  );

  Future<List<ExpressionResponse>> queryExpression(
      ExpressionQueryParams params);

  /// Returns a [QueryExpressionResults] containing a list of results which
  /// satisfies the query.
  Future<QueryResults<ExpressionResponse>> getCollectiveExpressions(
      Map<String, dynamic> params);

  /// Returns mock expression data.
  List<ExpressionResponse> get collectiveExpressions;

  Future<void> deleteExpression(String expressionAddress);

  /// Added [users] to [expressionAddress]
  Future<List<Users>> addEventMember(
    String expressionAddress,
    List<Map<String, String>> users,
  );

  /// Retrive a list of members who RSVP to the passed expression
  Future<QueryResults<Users>> getEventMembers(
    String expressionAddress,
    Map<String, String> params,
  );
}

abstract class GroupService {
  List<Sphere> get spheres;

  /// Allows an authenticated user to create a sphere.
  Future<SphereResponse> createSphere(SphereModel sphere);

  Future<void> deleteGroup(String groupAddress);

  /// Returns a [Group] for the given address
  Future<Group> getGroup(String groupAddress);

  Future<Map<String, dynamic>> getRelationToGroup(
      String groupAddress, String userAddress);

  /// Returns a list of users in a group along with with their permission
  /// level.
  Future<QueryResults<Users>> getGroupMembers(
      String groupAddress, ExpressionQueryParams params);

  /// Adds the given user address to a group
  Future<void> addGroupMember(
      String groupAddress, List<Map<String, dynamic>> users);

  /// Removes a user from the given group. Sufficient permission is required
  /// to perform this action.
  Future<void> removeGroupMember(String groupAddress, String userAddress);

  Future<List<ExpressionResponse>> getGroupExpressions(
      String groupAddress, GroupExpressionQueryParams params);

  /// Allows for updating a group. The parameter [group] must not be null.
  Future<Group> updateGroup(Group group);

  Future<void> respondToGroupRequest(String groupAddress, bool decision);
}

enum QueryType { address, email, username }

abstract class UserService {
  /// Allows the user to create a [Perspective] on the server.
  Future<PerspectiveModel> createPerspective(Perspective perspective);

  /// Allows the user to delete a [Perspective] .
  Future<void> deletePerspective(String perspective);

  Future<PerspectiveModel> updatePerspective(
    String perspectiveAddress,
    Map<String, String> perspectiveBody,
  );

  /// Gets the user
  Future<UserData> getUser(String userAddress);

  /// Returns the [UserProfile] for the given [QueryType]
  Future<UserProfile> queryUser(String param, QueryType queryType);

  /// Returns a [PerspectiveModel] containing a list of `user`s who are
  /// apart of the given perspective.
  Future<List<PerspectiveModel>> getUserPerspective(String userAddress);

  /// Returns a list of users in a group. Note: The return type of this
  /// function is [PerspectiveModel] since the response sent back from
  /// the server is identical to [getUserPerspective]
  Future<UserGroupsResponse> getUserGroups(String userAddress);

  /// Currently under development server-side.
  Future<List<ExpressionResponse>> getUsersResonations(String userAddress);

  /// Placeholder for now, currently under development server-side.
  Future<QueryResults<ExpressionResponse>> getUsersExpressions(
    String userAddress,
    int paginationPos,
    String lastTimestamp,
  );

  /// Returns a list of perspectives owned by the given user
  Future<List<PerspectiveModel>> userPerspectives(String userAddress);

  Future<UserProfile> createPerspectiveUserEntry(
    String userAddress,
    String perspectiveAddress,
  );

  /// Adds the given user to a perspective. The perspective address and user
  /// address must be supplied.
  Future<void> addUsersToPerspective(
      String perspectiveAddress, List<String> userAddresses);

  /// Uses a Delete request.
  Future<void> deleteUsersFromPerspective(
    List<Map<String, String>> userAddresses,
    String perspectiveAddress,
  );

  Future<List<UserProfile>> getPerspectiveUsers(
    String perspectiveAddress,
  );

  /// Connects to the user with the given address.
  Future<void> connectUser(String userAddress);

  /// Removes the user's connection with the given address
  Future<void> removeUserConnection(String userAddress);

  /// Responds to the connection with either `true` or `false`
  Future<void> respondToConnection(String userAddress, bool response);

  /// Gets a list of pending user connections
  Future<Map<String, dynamic>> userRelations();

  /// Gets a list of pending user connections
  Future<List<UserProfile>> connectedUsers(String userAddress);

  /// Returns true/false of user's relations to another member
  Future<Map<String, dynamic>> isRelated(
      String userAddress, String targetAddress);

  /// Returns true/false if the [userAddress] is following the [targetAddress]
  Future<bool> isFollowingUser(String userAddress, String targetAddress);

  /// Returns true/false if the [userAddress] is connected to the [targetAddress]
  Future<bool> isConnectedUser(String userAddress, String targetAddress);

  /// Updates the given [user] and returns updated [UserData]
  Future<Map<String, dynamic>> updateUser(
      Map<String, dynamic> profile, String userAddress);

  // Returns a list of followers for the given user address.
  Future<List<UserProfile>> getFollowers(String userAddress);
}

/// App wide notification service
abstract class NotificationService {
  Future<JuntoNotificationResults> getJuntoNotifications(
      NotificationQuery params);
}

enum DBBoxes {
  collectiveExpressions,
  denExpressions,
  packExpressions,
  notifications,
}

/// Interface for managing the application's local cache.
abstract class LocalCache {
  /// Adds [expressions] to the database.
  Future<void> insertExpressions(
    List<ExpressionResponse> expressions,
    DBBoxes box,
  );

  /// Retrieves all expressions in the database.
  Future<List<ExpressionResponse>> retrieveExpressions(DBBoxes box);

  /// Adds list of notifications to database
  Future<void> insertNotifications(List<JuntoNotification> notifications,
      {bool overwrite});

  /// Retrieves all cached notifications
  Future<List<JuntoNotification>> retrieveNotifications();

  //  Deletes a notification from cache
  Future<void> deleteNotification(String notificationKey);

  Future<void> wipe();
}
