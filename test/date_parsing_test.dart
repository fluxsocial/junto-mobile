import 'package:test/test.dart';
import 'package:junto_beta_mobile/utils/utils.dart';

void main() {
  test('Verify RFC3339 Parsing works', () {
    final DateTime result = RFC3339.parseRfc3339(
      '2019-05-31T10:35:45.347333481Z',
    );
    expect(result.year, 2019);
    expect(result.month, 5);
    expect(result.day, 31);
  });
}

//2019-05-31T10:35:45.347333481Z
