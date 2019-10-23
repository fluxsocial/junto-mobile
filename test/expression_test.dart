import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:junto_beta_mobile/app/api.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/backend/services/expression_provider.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:shared_preferences/shared_preferences.dart';

//TODO(Nash): For server testing, test currently make live http calls. Once
//server and functions becomes stable, these should be mocked.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null;
  final ExpressionProvider _collectiveProvider = ExpressionProviderCentralized(JuntoHttp());

  setUpAll(() {
    SharedPreferences.setMockInitialValues(<String, String>{
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
    /// Returns the test user expression
    test('Get User Expression', () async {
      final CentralizedExpressionResponse _response =
          await _collectiveProvider.getExpression('9f878873-3ad8-45e2-8f1b-5c3673f73e27');
      expect(_response.type, 'ShortForm');
      expect(_response.creator.address, '85235b21-1725-4e89-b6fa-305df7978e52');
    });

    /// Ensure the value sent back is not null
    test('Get Expression Comments', () async {
      final List<Comment> _response =
          await _collectiveProvider.getExpressionsComments('9f878873-3ad8-45e2-8f1b-5c3673f73e27');
      expect(_response, isNotNull);
    });

    /// Ensure the value sent back is not null
    test('Get Expression Resonation', () async {
      final List<UserProfile> _response =
          await _collectiveProvider.getExpressionsResonation('9f878873-3ad8-45e2-8f1b-5c3673f73e27');
      expect(_response, isNotNull);
    });
  });
}
