import 'package:meta/meta.dart';

class AppModel {
  AppModel({
    @required this.minAndroidBuild,
    @required this.minAndroidBuildTest,
    @required this.minIosBuild,
    @required this.minIosBuildTest,
  });

  static fromJson(Map<String, dynamic> json) {
    return AppModel(
      minAndroidBuild: num.parse(json['min_android_build']),
      minAndroidBuildTest: num.parse(json['min_android_build_test']),
      minIosBuild: num.parse(json['min_ios_build']),
      minIosBuildTest: num.parse(json['min_ios_build_test']),
    );
  }

  final num minAndroidBuild;
  final num minAndroidBuildTest;
  final num minIosBuild;
  final num minIosBuildTest;
}
