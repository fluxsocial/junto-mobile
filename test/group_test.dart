import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/backend/services/group_service.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/sphere.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null;
  final GroupService _sphereProvider = GroupServiceCentralized(JuntoHttp());

  setUpAll(() {
    SharedPreferences.setMockInitialValues(<String, String>{
      'flutter.auth': kMockCookie,
    });
  });
  test('Create Sphere', () async {
    final SphereResponse _result = await _sphereProvider.createSphere(
      SphereModel(
        photo: '',
        name: 'Testing Sphere',
        description: 'This was created from a test',
        privacy: 'Public',
        principles: 'Do not be a bad person in life',
        facilitators: <String>[
          '85235b21-1725-4e89-b6fa-305df7978e52',
        ],
        sphereHandle: 'WeLoveMacBookPros',
        members: <String>['40118b16-a07e-47c0-8369-e6624cdc7988'],
      ),
    );
    expect(_result.address, isNotNull);
    expect(_result.creator, '85235b21-1725-4e89-b6fa-305df7978e52');
    expect(_result.privacy, 'Public');
  });
  test('Get Group', () async {
    final Group _result =
        await _sphereProvider.getGroup('873cea53-4a59-45ee-b717-bbf41a102e11');
    expect(_result.address, '873cea53-4a59-45ee-b717-bbf41a102e11');
    expect(_result.creator, '85235b21-1725-4e89-b6fa-305df7978e52');
    expect(_result.privacy, 'Public');
  });
  test('Group Users', () async {
    final List<Users> _result = await _sphereProvider
        .getGroupMembers('873cea53-4a59-45ee-b717-bbf41a102e11');
    expect(_result, isNotNull);
  });
}
