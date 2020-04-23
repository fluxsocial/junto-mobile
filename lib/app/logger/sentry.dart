import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:package_info/package_info.dart';
import 'package:sentry/sentry.dart';

final SentryClient _sentry = SentryClient(dsn: kSentryDSN);

bool get isInDebugMode {
  return !kReleaseMode;
}

Future<void> reportError(dynamic error, dynamic stackTrace) async {
  logger.logError('Caught error: $error');

  if (isInDebugMode) {
    logger.logDebug('In dev mode. Not sending report to Sentry.io.');
    return;
  }

  logger.logInfo('Reporting to Sentry.io...');

  final systemVersion = Platform.operatingSystemVersion;
  final version = await PackageInfo.fromPlatform();
  final response = await _sentry.capture(
    event: Event(
      release: version.buildNumber,
      message: error.toString(),
      environment: Platform.isAndroid ? 'Android' : 'iOS',
      stackTrace: stackTrace,
      exception: error,
      tags: {
        'packageName': version.packageName,
        'version': version.version,
        'build': version.buildNumber,
        'systemVersion': systemVersion,
      },
    ),
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

  runZonedGuarded(
    () => runApp(app),
    (dynamic error, dynamic stackTrace) async {
      await reportError(error, stackTrace);
    },
  );
}
