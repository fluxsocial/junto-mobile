
import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/sphere.dart';

void main() {
  test('test fetchExpressions', () {
    final sphere = Sphere.fetchAll();

    expect(sphere, isNotNull);
  });
}