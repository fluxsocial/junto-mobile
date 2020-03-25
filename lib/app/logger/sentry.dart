import 'dart:async';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:sentry/sentry.dart';

final SentryClient _sentry = SentryClient(dsn: kSentryDSN);

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

Future<void> reportError(dynamic error, dynamic stackTrace) async {
  logger.logError('Caught error: $error');

  if (isInDebugMode) {
    logger.logDebug('In dev mode. Not sending report to Sentry.io.');
    return;
  }

  logger.logInfo('Reporting to Sentry.io...');

  final SentryResponse response = await _sentry.captureException(
    exception: error,
    stackTrace: stackTrace,
  );

  if (response.isSuccessful) {
    logger.logInfo('Success! Event ID: ${response.eventId}');
  } else {
    logger.logInfo('Failed to report to Sentry.io: ${response.error}');
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
      await reportError(error, stackTrace);
    },
  );
}
