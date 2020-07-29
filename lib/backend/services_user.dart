part of 'services.dart';

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
    bool rootExpressions,
    bool subExpressions,
    bool communityFeedback,
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

  /// After successful signup we need to send user data to backend
  Future<UserData> sendMetadataPostRegistration(
      UserRegistrationDetails details);

  /// Returns a list of followers for the given user address.
  Future<List<UserProfile>> getFollowers(String userAddress);

  /// Checks if username and email are valid
  Future<ValidUserModel> validateUser(String email, String username);

  /// Checks the given string against existing/reserved  username
  Future<ValidUserModel> validateUsername(String username);

  /// Removes the user account.
  Future<void> deleteUser(String email);

  /// Validate/Delete Un-confirmed Cognito User
  ///
  /// If user had previously created account and not verified it during sign up
  /// and tries to sign up again with the same username
  /// Then the previous account is deleted on Cognito
  /// to allow new signup
  Future<bool> cognitoValidate(String username);

  // invite user to Junto
  Future<int> inviteUser(String email, String name);
}
