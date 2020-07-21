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
      minAndroidBuild: int.parse(json['min_android_build']),
      minAndroidBuildTest: int.parse(json['min_android_build_test']),
      minIosBuild: int.parse(json['min_ios_build']),
      minIosBuildTest: int.parse(json['min_ios_build_test']),
    );
  }

  final int minAndroidBuild;
  final int minAndroidBuildTest;
  final int minIosBuild;
  final int minIosBuildTest;
}
