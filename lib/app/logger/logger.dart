import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:junto_beta_mobile/app/logger/sentry.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:stack_trace/stack_trace.dart';

abstract class Logger {
  const Logger();

  void logDebug(String message);
  void logError(String message);
  void logException(dynamic ex, [StackTrace stackTrace, String message]);
  void logWarning(String message);
  void logInfo(String message);
}

class PrintLogger extends Logger {
  String getMethodName() {
    final frames = Trace.current().frames;
    final frame = frames[3].member;

    return '[$frame]';
  }

  @override
  void logDebug(String message) {
    final meta = getMethodName();
    debugPrint('[DEBUG] $meta: $message');
  }

  @override
  void logError(String message) {
    final meta = getMethodName();
    debugPrint('[ERROR] $meta: $message');
  }

  @override
  void logException(ex, [StackTrace stackTrace, String message]) {
    if (message != null) {
      debugPrint(message);
    }
    if (ex is Error) {
      debugPrint(ex.toString());
    } else if (ex is JuntoException) {
      debugPrint('[JuntoException] ${ex.message}');
      debugPrint('[ErrorCode] ${ex.errorCode}');
    } else if (ex is PlatformException) {
      debugPrint(ex.message);
    } else if (ex is Exception) {
      debugPrint(ex.toString());
    } else {
      debugPrint(ex);
    }
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }

    reportError(ex, stackTrace);
  }

  @override
  void logInfo(String message) {
    final meta = getMethodName();
    debugPrint('$meta: $message');
  }

  @override
  void logWarning(String message) {
    final meta = getMethodName();
    debugPrint('[WARNING] $meta: $message');
  }
}

Logger logger = PrintLogger();
