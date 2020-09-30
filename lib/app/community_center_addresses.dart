import 'package:junto_beta_mobile/app/app_config.dart';

final String kCommunityCenterAddress = appConfig.flavor == Flavor.prod
    ? '0ab99620-8835-d63b-3836-f091992ca2b4'
    : '80ba6100-cf6e-cc3c-cb8c-c945c82e8446';

// updates address
String kUpdatesAddress = appConfig.flavor == Flavor.prod
    ? '98b99620-ca1f-fda2-060d-d1a22f1de6d2'
    : '3eba6101-0240-f2a7-ecfe-f15440d7f02e';
