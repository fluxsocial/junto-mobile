import 'package:junto_beta_mobile/app/app_config.dart';

final String kCommunityCenterAddress = appConfig.flavor == Flavor.prod
    ? '0ab99620-8835-d63b-3836-f091992ca2b4'
    : 'f4ba49eb-871e-fd62-e391-30a7387795af';

// updates address
String kUpdatesAddress = appConfig.flavor == Flavor.prod
    ? '98b99620-ca1f-fda2-060d-d1a22f1de6d2'
    : '46ba49eb-b476-9ade-6940-e57059ce2fc8';
