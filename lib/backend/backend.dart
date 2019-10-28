import 'package:http/io_client.dart';
import 'package:junto_beta_mobile/backend/mock/mock_expression.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/backend/services/auth_service.dart';
import 'package:junto_beta_mobile/backend/services/collective_provider.dart';
import 'package:junto_beta_mobile/backend/services/search_provider.dart';
import 'package:junto_beta_mobile/backend/services/group_service.dart';
import 'package:junto_beta_mobile/backend/services/user_service.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';

export 'package:junto_beta_mobile/backend/repositories.dart';
export 'package:junto_beta_mobile/backend/services.dart';

class Backend {
  const Backend._({
    this.searchProvider,
    this.authRepo,
    this.userProvider,
    this.collectiveProvider,
    this.groupsProvider,
    this.expressionRepo,
  });

  static Future<Backend> init() async {
    final JuntoHttp client = JuntoHttp(httpClient: IOClient());
    final AuthenticationServiceCentralized authService =
        AuthenticationServiceCentralized(client);
    final UserServiceCentralized userService = UserServiceCentralized(client);
    final ExpressionService expressionService = MockExpressionService();
    final GroupService groupService = GroupServiceCentralized(client);
    return Backend._(
      searchProvider: SearchProviderCentralized(client),
      authRepo: AuthRepo(authService, userService),
      userProvider: userService,
      collectiveProvider: CollectiveProviderCentralized(client),
      groupsProvider: GroupRepo(groupService),
      expressionRepo: ExpressionRepo(expressionService),
    );
  }

  final SearchProvider searchProvider;
  final AuthRepo authRepo;
  final UserService userProvider;
  final CollectiveService collectiveProvider;
  final GroupRepo groupsProvider;
  final ExpressionRepo expressionRepo;
}
