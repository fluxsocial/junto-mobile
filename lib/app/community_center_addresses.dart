import 'package:junto_beta_mobile/app/app_config.dart';

final String kCommunityCenterAddress = appConfig.flavor == Flavor.prod
    ? '0ab99620-8835-d63b-3836-f091992ca2b4'
    : '9aba84ed-fb00-02bc-1c20-d353fb6a505d';

// updates address
String kUpdatesAddress = appConfig.flavor == Flavor.prod
    ? '98b99620-ca1f-fda2-060d-d1a22f1de6d2'
    : '98ba84ee-23e1-955a-e7cc-ac57344750a2';
