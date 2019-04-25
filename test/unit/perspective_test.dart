
import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/perspective.dart';

void main() {
  test('test fetchExpressions', () {
    final perspective = Perspective.fetchAll();

    expect(perspective, isNotNull);
  });
}