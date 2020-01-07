import 'package:http/io_client.dart';
import 'package:junto_beta_mobile/backend/mock/mock_auth.dart';
import 'package:junto_beta_mobile/backend/mock/mock_expression.dart';
import 'package:junto_beta_mobile/backend/mock/mock_sphere.dart';
import 'package:junto_beta_mobile/backend/mock/mock_user.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/backend/services/auth_service.dart';
import 'package:junto_beta_mobile/backend/services/collective_provider.dart';
import 'package:junto_beta_mobile/backend/services/expression_provider.dart';
import 'package:junto_beta_mobile/backend/services/group_service.dart';
import 'package:junto_beta_mobile/backend/services/search_provider.dart';
import 'package:junto_beta_mobile/backend/services/user_service.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';

export 'package:junto_beta_mobile/backend/repositories.dart';
export 'package:junto_beta_mobile/backend/services.dart';

class Backend {
  const Backend._({
    this.searchProvider,
    this.authRepo,
    this.userRepo,
    this.collectiveProvider,
    this.groupsProvider,
    this.expressionRepo,
  });

  static Future<Backend> init() async {
    final JuntoHttp client = JuntoHttp(httpClient: IOClient());
    final AuthenticationService authService =
        AuthenticationServiceCentralized(client);
    final UserService userService = UserServiceCentralized(client);
    final ExpressionService expressionService =
        ExpressionServiceCentralized(client);
    final GroupService groupService = GroupServiceCentralized(client);
    return Backend._(
      searchProvider: SearchProviderCentralized(client),
      authRepo: AuthRepo(authService),
      userRepo: UserRepo(userService),
      collectiveProvider: CollectiveProviderCentralized(client),
      groupsProvider: GroupRepo(groupService),
      expressionRepo: ExpressionRepo(expressionService),
    );
  }

  static Future<Backend> mocked() async {
    final AuthenticationService authService = MockAuth();
    final UserService userService = MockUserService();
    final ExpressionService expressionService = MockExpressionService();
    final GroupService groupService = MockSphere();
    return Backend._(
      searchProvider: null,
      authRepo: AuthRepo(authService),
      userRepo: UserRepo(userService),
      collectiveProvider: null,
      groupsProvider: GroupRepo(groupService),
      expressionRepo: ExpressionRepo(expressionService),
    );
  }

  final SearchProvider searchProvider;
  final AuthRepo authRepo;
  final UserRepo userRepo;
  final CollectiveService collectiveProvider;
  final GroupRepo groupsProvider;
  final ExpressionRepo expressionRepo;
}
