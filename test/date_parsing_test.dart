import 'package:test/test.dart';
import 'package:junto_beta_mobile/utils/utils.dart';

void main() {
  test('Verify RFC3339 Parsing works', () {
    final DateTime result = RFC3339.parseRfc3339(
      '2019-11-10T12:20:23.150287836',
    );
    expect(result.year, 2019);
    expect(result.month, 11);
    expect(result.day, 10);
    expect(result.hour, 12);
    expect(result.minute, 20);
  });
}
