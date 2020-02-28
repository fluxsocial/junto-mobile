import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';

class GroupRepo {
  GroupRepo(this._groupService);

  final GroupService _groupService;

  Future<CentralizedSphereResponse> createSphere(CentralizedSphere sphere) {
    return _groupService.createSphere(sphere);
  }

  Future<Group> getGroup(String groupAddress) {
    return _groupService.getGroup(groupAddress);
  }

  Future<List<Users>> getGroupMembers(String groupAddress) {
    return _groupService.getGroupMembers(groupAddress);
  }

  Future<void> addGroupMember(
      String groupAddress, List<UserProfile> userProfile, String perms) {
    final List<Map<String, dynamic>> _users = <Map<String, dynamic>>[];
    for (final UserProfile _profile in userProfile) {
      _users.add(<String, dynamic>{
        'user_address': _profile.address,
        'permission_level': perms
      });
    }
    return _groupService.addGroupMember(groupAddress, _users);
  }

  Future<void> removeGroupMember(String groupAddress, String userAddress) {
    return _groupService.removeGroupMember(groupAddress, userAddress);
  }

  Future<List<ExpressionResponse>> getGroupExpressions(
      String groupAddress, GroupExpressionQueryParams params) {
    return _groupService.getGroupExpressions(groupAddress, params);
  }

  Future<Group> updateGroup(Group group) {
    assert(group.groupData.name != null);
    assert(group.groupData.description != null);
    assert(group.groupData.principles != null);
    return _groupService.updateGroup(group);
  }

  Future<void> respondToGroupRequest(String groupAddress, bool decision) {
    assert(groupAddress != null);
    assert(decision != null);
    return _groupService.respondToGroupRequest(groupAddress, decision);
  }
}
