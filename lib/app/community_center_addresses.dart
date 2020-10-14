import 'package:junto_beta_mobile/app/app_config.dart';

final String kCommunityCenterAddress = appConfig.flavor == Flavor.prod
    ? '0ab99620-8835-d63b-3836-f091992ca2b4'
    : 'c2ba8707-8642-4e88-2f05-bc3783732645';

// updates address
String kUpdatesAddress = appConfig.flavor == Flavor.prod
    ? '98b99620-ca1f-fda2-060d-d1a22f1de6d2'
    : 'dcba8707-b054-0be4-307d-db48f139c956';
