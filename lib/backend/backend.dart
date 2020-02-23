import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:junto_beta_mobile/app/themes.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/backend/mock/mock_auth.dart';
import 'package:junto_beta_mobile/backend/mock/mock_expression.dart';
import 'package:junto_beta_mobile/backend/mock/mock_search.dart';
import 'package:junto_beta_mobile/backend/mock/mock_sphere.dart';
import 'package:junto_beta_mobile/backend/mock/mock_user.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/backend/repositories/search_repo.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/backend/services/auth_service.dart';
import 'package:junto_beta_mobile/backend/services/collective_provider.dart';
import 'package:junto_beta_mobile/backend/services/expression_provider.dart';
import 'package:junto_beta_mobile/backend/services/group_service.dart';
import 'package:junto_beta_mobile/backend/services/notification_service.dart';
import 'package:junto_beta_mobile/backend/services/search_service.dart';
import 'package:junto_beta_mobile/backend/services/user_service.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';

export 'package:junto_beta_mobile/backend/repositories.dart';
export 'package:junto_beta_mobile/backend/services.dart';

class Backend {
  const Backend._({
    this.searchRepo,
    this.authRepo,
    this.userRepo,
    this.collectiveProvider,
    this.groupsProvider,
    this.expressionRepo,
    this.currentTheme,
    this.notificationRepo,
  });

  static Future<Backend> init() async {
    final ThemeData currentTheme = await JuntoThemesProvider.loadDefault();
    final JuntoHttp client = JuntoHttp(httpClient: IOClient());
    final AuthenticationService authService =
        AuthenticationServiceCentralized(client);
    final UserService userService = UserServiceCentralized(client);
    final ExpressionService expressionService =
        ExpressionServiceCentralized(client);
    final GroupService groupService = GroupServiceCentralized(client);
    final SearchService searchService = SearchServiceCentralized(client);
    final NotificationService notificationService =
        NotificationServiceImpl(client);
    return Backend._(
      searchRepo: SearchRepo(searchService),
      authRepo: AuthRepo(authService),
      userRepo: UserRepo(userService, notificationService),
      collectiveProvider: CollectiveProviderCentralized(client),
      groupsProvider: GroupRepo(groupService),
      expressionRepo: ExpressionRepo(expressionService),
      currentTheme: currentTheme,
      notificationRepo: NotificationRepo(notificationService),
    );
  }

  static Future<Backend> mocked() async {
    final AuthenticationService authService = MockAuth();
    final UserService userService = MockUserService();
    final ExpressionService expressionService = MockExpressionService();
    final GroupService groupService = MockSphere();
    final SearchService searchService = MockSearch();
    return Backend._(
        authRepo: AuthRepo(authService),
        userRepo: UserRepo(userService, null),
        collectiveProvider: null,
        groupsProvider: GroupRepo(groupService),
        expressionRepo: ExpressionRepo(expressionService),
        searchRepo: SearchRepo(searchService),
        currentTheme: JuntoThemes().aqueous);
  }

  final SearchRepo searchRepo;
  final AuthRepo authRepo;
  final UserRepo userRepo;
  final CollectiveService collectiveProvider;
  final GroupRepo groupsProvider;
  final ExpressionRepo expressionRepo;
  final NotificationRepo notificationRepo;
  final ThemeData currentTheme;
}
