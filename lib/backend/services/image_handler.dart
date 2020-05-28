import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:junto_beta_mobile/app/logger/logger.dart';

abstract class ImageHandler {
  Future<File> resizeImage(File file, int width);
}

class DeviceImageHandler implements ImageHandler {
  @override
  Future<File> resizeImage(File file, int width) async {
    try {
      logger.logInfo('Resizing image to $width');
      final image = img.decodeJpg(file.readAsBytesSync());
      final thumbnail = img.copyResize(image,
          width: width, interpolation: img.Interpolation.average);
      final name = file.path.replaceFirst('.jpg', '$width.jpg');
      final result = await File(name).writeAsBytes(img.encodeJpg(thumbnail));
      logger.logInfo('Resizing image to $width completed');
      return result;
    } catch (e, s) {
      logger.logException(e, s, 'Image resize failed');
      return null;
    }
  }
}

class MockedImageHandler implements ImageHandler {
  @override
  Future<File> resizeImage(File file, int width) async {
    return file;
  }
}
