import 'package:junto_beta_mobile/app/app_config.dart';

final String kCommunityCenterAddress = appConfig.flavor == Flavor.prod
    ? '0ab99620-8835-d63b-3836-f091992ca2b4'
    : '48b97134-1a4d-deb0-b27c-9bcdfc33f386';

// updates address
String kUpdatesAddress = appConfig.flavor == Flavor.prod
    ? '98b99620-ca1f-fda2-060d-d1a22f1de6d2'
    : '2eb976b4-4473-2436-ccb2-e512e868bcac';
