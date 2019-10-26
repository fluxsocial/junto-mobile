import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/backend/services/user_service.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:shared_preferences/shared_preferences.dart';

//TODO(Nash): For server testing, test currently make live http calls. Once
//server and functions becomes stable, these should be mocked.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null;
  final UserService _userProvider = UserServiceCentralized(JuntoHttp());

  setUpAll(() {
    SharedPreferences.setMockInitialValues(<String, String>{
      'flutter.auth': kMockCookie,
    });
  });

  group('Query User', () {
    test('Query user by email', () async {
      final UserProfile _profile = await _userProvider.queryUser(
        'mail@neevash'
        '.dev',
        QueryType.email,
      );
      expect(_profile, isNotNull);
      expect(_profile.lastName, 'Ramdial');
      expect(_profile.username, isNotNull);
      expect(_profile.address, isNotNull);
    });
    test('Query user by address', () async {
      final UserProfile _profile = await _userProvider.queryUser(
        '85235b21-1725-4e89-b6fa-305df7978e52',
        QueryType.address,
      );
      expect(_profile, isNotNull);
      expect(_profile.lastName, 'Ramdial');
      expect(_profile.username, isNotNull);
      expect(_profile.address, isNotNull);
    });
    test('Query user by username', () async {
      final UserProfile _profile = await _userProvider.queryUser(
        'Nash0x7E2',
        QueryType.username,
      );
      expect(_profile, isNotNull);
      expect(_profile.lastName, 'Ramdial');
      expect(_profile.username, isNotNull);
      expect(_profile.address, isNotNull);
    });
  });

  test('Get user', () async {
    final UserData _profile =
        await _userProvider.getUser('40118b16-a07e-47c0-8369-e6624cdc7988');
    expect(_profile.user, isNotNull);
    expect(_profile.user.firstName, 'joshua');
  });

  test('Get user perspective', () async {
    final List<CentralizedPerspective> _result = await _userProvider
        .getUserPerspective('85235b21-1725-4e89-b6fa-305df7978e52');
    expect(_result, isNotNull);
  });

  test('Get user groups', () async {
    final UserGroupsResponse _result = await _userProvider
        .getUserGroups('85235b21-1725-4e89-b6fa-305df7978e52');
    expect(_result, isNotNull);
    expect(_result.associated, isNotNull);
    expect(_result.owned, isNotNull);
  });

  test('Get user resonations', () async {
    final List<CentralizedExpressionResponse> _result = await _userProvider
        .getUsersResonations('85235b21-1725-4e89-b6fa-305df7978e52');
    expect(_result, isNotNull);
  });
  test('Get user expressions', () async {
    final List<CentralizedExpressionResponse> _result = await _userProvider
        .getUsersExpressions('85235b21-1725-4e89-b6fa-305df7978e52');
    expect(_result, isNotNull);
  });
  test('Returns the list of users in a perspective', () async {
    final List<UserProfile> _result = await _userProvider
        .getPerspectiveUsers('f450d938-f686-4c92-87d1-bed6f30f64ac');
    expect(_result, isNotNull);
  });
  test('Creating a  perspective', () async {
    final CentralizedPerspective _result =
        await _userProvider.createPerspective(
      const Perspective(
        name: 'Test Perspective',
        members: <String>['40118b16-a07e-47c0-8369-e6624cdc7988'],
      ),
    );
    expect(_result, isNotNull);
  });
}
