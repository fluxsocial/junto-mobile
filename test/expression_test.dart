import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:junto_beta_mobile/API.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/providers/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//TODO(Nash): For server testing, test currently make live http calls. Once
//server and functions becomes stable, these should be mocked.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null;
  final CollectiveProvider _collectiveProvider = CollectiveProviderCentralized();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({
      'flutter.auth': kMockCookie,
    });
  });

  group('Create Expression', () {
    test('Create LongForm Expression ', () async {
      final CentralizedExpressionResponse _response = await _collectiveProvider.createExpression(
        CentralizedExpression(
          type: 'LongForm',
          expressionData: CentralizedLongFormExpression(
            title: 'This is another test',
            body: 'Hi there',
          ).toMap(),
          context: <String, dynamic>{
            'Group': <String, dynamic>{'address': 'd7f5186b-0281-4723-b5d4-1ff24eb0beb2'}
          },
        ),
      );
      expect(_response.type, 'LongForm');
      expect(_response.address, isNotNull);
      expect(_response.creator, isNotNull);
    });
    test('Create ShortForm Expression ', () async {
      final CentralizedExpressionResponse _response = await _collectiveProvider.createExpression(
        CentralizedExpression(
          type: 'ShortForm',
          expressionData: CentralizedShortFormExpression(
            background: '#FFFF',
            body: 'Test ShortForm expression',
          ).toMap(),
          context: <String, dynamic>{
            'Group': <String, dynamic>{'address': 'd7f5186b-0281-4723-b5d4-1ff24eb0beb2'}
          },
        ),
      );
      expect(_response.type, 'ShortForm');
      expect(_response.address, isNotNull);
      expect(_response.creator, isNotNull);
    });
  });

  group('Expression Interaction', () {
    test('Get User Expression', () async {
      final CentralizedExpressionResponse _response =
          await _collectiveProvider.getExpression('9f878873-3ad8-45e2-8f1b-5c3673f73e27');
      expect(_response.type, 'ShortForm');
      expect(_response.creator.address, '85235b21-1725-4e89-b6fa-305df7978e52');
    });
  });
}
