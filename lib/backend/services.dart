import 'dart:io';

import 'package:junto_beta_mobile/models/auth_result.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/junto_notification_cache.dart';
import 'package:junto_beta_mobile/models/junto_notification_results.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/notification_query.dart';

part 'services_auth.dart';
part 'services_user.dart';

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

  /// Replaces list of notifications in database
  Future<void> replaceNotifications(List<JuntoNotification> notifications);

  /// Retrieves all cached notifications
  Future<JuntoNotificationCache> retrieveNotifications();

  ///  Deletes a notification from cache
  Future<void> deleteNotification(String notificationKey);

  /// Stores the last read notification time
  Future<void> setLastReadNotificationTime(DateTime datetime);

  /// Fetches all stored perspectives
  Future<List<PerspectiveModel>> retrievePerspective();

  /// Insert user perspectives
  Future<void> insertPerspectives(List<PerspectiveModel> perspectives);

  /// Clears all stored data
  Future<void> wipe();
}

abstract class AppService {
  Future<AppModel> getServerVersion();
}