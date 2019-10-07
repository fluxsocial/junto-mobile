import 'package:junto_beta_mobile/models/pack.dart';

/// Interface describing the functions and responsibilities of Pack provider.
/// Please see [PacksProviderImpl] for implementation.
abstract class PacksProvider {
  /// Returns mock list of packs.
  List<Pack> get packs;

  /// Adds a member to a pack.
  Future<String> addMemberToPack(String usernameAddress);

  /// Adds the user address provided to the group passed.
  Future<void> addMemberToGroup(String usernameAddress, String groupAddress);

  /// Removes a member from the given group.
  Future<String> removeGroupMember(String userAddress, String groupAddress);

  /// Returns a boolean indicating whether the user is a member of the given
  /// group.
  Future<bool> isGroupMember(String userAddress, String groupAddress);

  /// Returns a boolean indicating whether the user is the owner of the given
  /// group.
  Future<bool> isGroupOwner(String userAddress, String groupAddress);

  /// Returns a list [Username] of members in the given group.
  /// ```
  ///{ "members": [{"address": "address of user username", "entry": {"username": "username of user"}} ] }
  ///  ```
  Future<List> getGroupMembers(String groupAddress);

  /// Gets the user created packs.
  /// Result a List of [PackResponse]
  /// Map data contains:
  /// ```
  ///  {"address": "pack address", "entry": {"name": "pack name", "owner": "user address", "privacy": "Shared"}}
  ///  ```
  Future<List<PackResponse>> getUserPacks(String userAddress);

  /// Gets the packs the user is apart of.
  /// Result a List of [PackResponse]
  /// Map data contains:
  /// ```
  /// [
  //{"address": "pack address", "entry": {"name": "pack name", "owner": "user address", "privacy": "Shared"}},
  //            ...
  //]
  // ```
  Future<List<PackResponse>> getUserMemberPack(String userAddress);
}
