import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/utils/junto_http.dart';

void main() {
  group('Verify responses are handled correctly', () {
    test('Handle HTTP 200 request', () {
      final http.Response _blankResponse = http.Response('', 200);
      final http.Response _dataResponse = http.Response(
        "\"{'name': 'Junto'}\"",
        200,
      );
      final dynamic _blankResult = JuntoHttp.handleResponse(_blankResponse);
      final dynamic _dataResult = JuntoHttp.handleResponse(_dataResponse);
      expect(_blankResult, isNull);
      expect(_dataResult, isNotNull);
    });
  });
}
