
import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/pack.dart';

void main() {
  test('test fetchExpressions', () {
    final pack = Pack.fetchAll();

    expect(pack, isNotNull);
  });
}