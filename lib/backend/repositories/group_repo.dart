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
      String groupAddress, String userAddress, String perms) {
    return _groupService.addGroupMember(groupAddress, userAddress, perms);
  }

  Future<void> removeGroupMember(String groupAddress, String userAddress) {
    return _groupService.removeGroupMember(groupAddress, userAddress);
  }
}
