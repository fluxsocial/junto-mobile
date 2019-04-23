
import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/expression.dart';

void main() {
  test('Test fetchAll', () {
    final expressions = Expression.fetchAll();

    expect(expressions, isNotNull);
  });
} 