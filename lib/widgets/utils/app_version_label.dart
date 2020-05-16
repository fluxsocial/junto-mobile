import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AppVersionLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isMacOS) {
      return Container();
    }
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final ver = snapshot.data;
          return Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${ver.version} (${ver.buildNumber})',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
