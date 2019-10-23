import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:junto_beta_mobile/API.dart';
import 'package:junto_beta_mobile/models/collective.dart';
import 'package:junto_beta_mobile/providers/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null;
  final CollectiveProvider _collectiveProvider = CollectiveProviderCentralized();

  setUpAll(() {
    SharedPreferences.setMockInitialValues(<String, String>{
      'flutter.auth': kMockCookie,
    });
  });
  test('Create Collection', () async {
    final Collective result = await _collectiveProvider.createCollection('Test Collection', 'Public');
    expect(result.address, isNotNull);
    expect(result.createdAt, isNotNull);
    expect(result.creator, isNotNull);
    expect(result.privacy, 'Public');
  });
  test('Get Collection', () async {
    //TODO:Implement once server is complete
  });
  test('Add Collection Expression', () async {
    //TODO:Implement once server is complete
  });
}
