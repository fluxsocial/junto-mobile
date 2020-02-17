import 'package:flutter/material.dart';

/// Top level function which handles parsing and rendering dates.
/// Function requires the `BuildContext`, [context], of the current widget and the `DateTime`, [time].
/// Dates are rendered as follows:
/// 1. Dates that are less that 24 hours old are rendered as `Today`
/// 2. Dates that are that 48 hours old are rendered as `Yesterday`
/// 3. Dates that are that less than a week old are rendered using a day count `3 days ago ... 1 week`
/// 4. Dates older than are week are formatted and rendered by MaterialLocalizations `Monday, June 4, 2001`
String parseDate(BuildContext context, DateTime time) {
  // Current date in UTC
  final DateTime currentDate = DateTime.now().toUtc();

  // Ensure the passed time is in `UTC` and independent of any timezones.
  final Duration timeDifference = currentDate.difference(time.toUtc());

  // Calculate the difference in time from the give date to the current date.
  final int elapsedTimeInHours = timeDifference.inHours;
  if (elapsedTimeInHours <= 24) {
    return 'Today';
  } else if (elapsedTimeInHours >= 25 && elapsedTimeInHours <= 48) {
    return 'Yesterday';
  } else if (elapsedTimeInHours > 48 && elapsedTimeInHours <= 168) {
    return '${timeDifference.inDays} days ago';
  } else if (elapsedTimeInHours > 168 && elapsedTimeInHours <= 192) {
    return '1 week ago';
  } else {
    return MaterialLocalizations.of(context).formatFullDate(time.toLocal());
  }
}
