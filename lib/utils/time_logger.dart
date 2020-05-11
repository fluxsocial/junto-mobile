/*
* Originally Written by: @CaiJingLong
*  https://github.com/OpenFlutter/flutter_image_compress/blob/master/example/lib/time_logger.dart
*
* */
import 'package:junto_beta_mobile/app/logger/logger.dart';

class TimeLogger {
  String tag;

  TimeLogger([this.tag = ""]);

  int start;

  void startRecoder() {
    start = DateTime.now().millisecondsSinceEpoch;
  }

  void logTime() {
    final diff = DateTime.now().millisecondsSinceEpoch - start;
    if (tag != "") {
      logger.logDebug("$tag : $diff ms");
    } else {
      logger.logDebug("run time $diff ms");
    }
  }
}