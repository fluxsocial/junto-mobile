import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/app/app_config.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/app_model.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:dio/dio.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';

class AppServiceImpl extends AppService {
  @override
  Future<AppModel> getServerVersion() async {
    try {
      Response response;
      if (appConfig.flavor == Flavor.prod) {
        response = await Dio().get("https://$END_POINT_without_prefix");
        final map = JuntoHttp.handleResponse(response);
        return AppModel.fromJson(map);
      } else {
        return currentAppVersion;
      }
    } catch (e, s) {
      logger.logException(e, s);
      throw JuntoException("Cannot get server version", -1);
    }
  }
}
