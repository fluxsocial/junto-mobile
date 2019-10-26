import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/models.dart';

@visibleForTesting
class MockSphere with ChangeNotifier implements GroupService {
  final List<Sphere> _spheres = Sphere.fetchAll();

  @override
  List<Sphere> get spheres {
    return _spheres;
  }

  @override
  Future<CentralizedSphereResponse> createSphere(CentralizedSphere sphere) {
    throw UnimplementedError();
  }

  @override
  Future<Group> getGroup(String groupAddress) {
    throw UnimplementedError();
  }

  @override
  Future<void> addGroupMember(
    String groupAddress,
    String userAddress,
    String perms,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeGroupMember(String groupAddress, String userAddress) {
    throw UnimplementedError();
  }

  @override
  Future<List<Users>> getGroupMembers(String groupAddress) {
    throw UnimplementedError();
  }
}
