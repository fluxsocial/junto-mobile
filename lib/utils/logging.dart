import 'dart:async';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/API.dart';
import 'package:sentry/sentry.dart';

final SentryClient _sentry = SentryClient(dsn: kSentryDSN);

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  print('Caught error: $error');

  if (isInDebugMode) {
    print(stackTrace);
    print('In dev mode. Not sending report to Sentry.io.');
    return;
  }

  print('Reporting to Sentry.io...');

  final SentryResponse response = await _sentry.captureException(
    exception: error,
    stackTrace: stackTrace,
  );

  if (response.isSuccessful) {
    print('Success! Event ID: ${response.eventId}');
  } else {
    print('Failed to report to Sentry.io: ${response.error}');
  }
}

Future<void> runLoggedApp(Widget app) async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZoned<Future<void>>(
    () async {
      runApp(app);
    },
    onError: (dynamic error, dynamic stackTrace) async {
      await _reportError(error, stackTrace);
    },
  );
}
