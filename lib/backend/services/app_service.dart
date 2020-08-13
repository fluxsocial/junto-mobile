import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/app/app_config.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/app_model.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/utils/junto_http.dart';

class AppServiceImpl extends AppService {
  @override
  Future<AppModel> getServerVersion() async {
    try {
      http.Response response;
      if (appConfig.flavor == Flavor.prod) {
        response = await http.get("https://$END_POINT_without_prefix");
        final map = JuntoHttp.handleResponse(response);
        return AppModel.fromJson(map);
      } else {
        return currentAppVersion;
      }
    } catch (error) {
      logger.logException(error);
      throw JuntoException("Cannot get server version", -1);
    }
  }
}
