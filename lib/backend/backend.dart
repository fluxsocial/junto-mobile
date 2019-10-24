import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/backend/services/auth_service.dart';
import 'package:junto_beta_mobile/backend/services/collective_provider.dart';
import 'package:junto_beta_mobile/backend/services/expression_provider.dart';
import 'package:junto_beta_mobile/backend/services/search_provider.dart';
import 'package:junto_beta_mobile/backend/services/spheres_provider.dart';
import 'package:junto_beta_mobile/backend/services/user_service.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:http/io_client.dart';

export 'package:junto_beta_mobile/backend/repositories.dart';
export 'package:junto_beta_mobile/backend/services.dart';

class Backend {
  const Backend._({
    this.searchProvider,
    this.authRepo,
    this.userRepo,
    this.collectiveProvider,
    this.spheresProvider,
    this.expressionProvider,
  });

  static Future<Backend> init() async {
    final JuntoHttp client = JuntoHttp(httpClient: IOClient());
    final AuthenticationServiceCentralized authService = AuthenticationServiceCentralized(client);
    final UserServiceCentralized userService = UserServiceCentralized(client);
    return Backend._(
      searchProvider: SearchProviderCentralized(client),
      authRepo: AuthRepo(authService, userService),
      userRepo: UserRepo(userService),
      collectiveProvider: CollectiveProviderCentralized(client),
      spheresProvider: SphereProviderCentralized(client),
      expressionProvider: ExpressionProviderCentralized(client),
    );
  }

  final SearchProvider searchProvider;
  final AuthRepo authRepo;
  final UserRepo userRepo;
  final CollectiveProvider collectiveProvider;
  final SpheresProvider spheresProvider;
  final ExpressionProvider expressionProvider;
}
