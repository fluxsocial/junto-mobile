import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:junto_beta_mobile/widgets/utils/date_parsing.dart';
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
  testWidgets('Parse date for display', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            DateTime time = DateTime.utc(2001, 06, 04);
            String output = parseDate(context, time);
            // call to material localization
            expect(output, 'Monday, June 4, 2001');
            time = DateTime.now();
            // Testing today's date
            output = parseDate(context, time);
            expect(output, 'Today');
            // Yesterday's date
            time = DateTime(2020, 01, 10);
            output = parseDate(context, time);
            expect(output, 'Yesterday');
            // days count
            time = DateTime(2020, 01, 9);
            output = parseDate(context, time);
            expect(output, '2 days ago');

            time = DateTime(2020, 01, 8);
            output = parseDate(context, time);
            expect(output, '3 days ago');

            time = DateTime(2020, 01, 4);
            output = parseDate(context, time);
            expect(output, '7 days ago');
            return const Placeholder();
          },
        ),
      ),
    );
  });
}
