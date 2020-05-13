import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/app/themes.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/backend/mock/mock_auth.dart';
import 'package:junto_beta_mobile/backend/mock/mock_expression.dart';
import 'package:junto_beta_mobile/backend/mock/mock_search.dart';
import 'package:junto_beta_mobile/backend/mock/mock_sphere.dart';
import 'package:junto_beta_mobile/backend/mock/mock_user.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/backend/repositories/search_repo.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/backend/services/auth_service.dart';
import 'package:junto_beta_mobile/backend/services/collective_provider.dart';
import 'package:junto_beta_mobile/backend/services/expression_provider.dart';
import 'package:junto_beta_mobile/backend/services/group_service.dart';
import 'package:junto_beta_mobile/backend/services/hive_service.dart';
import 'package:junto_beta_mobile/backend/services/notification_service.dart';
import 'package:junto_beta_mobile/backend/services/search_service.dart';
import 'package:junto_beta_mobile/backend/services/user_service.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';

export 'package:junto_beta_mobile/backend/repositories.dart';
export 'package:junto_beta_mobile/backend/services.dart';
export 'package:junto_beta_mobile/backend/user_data_provider.dart';

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
    this.appRepo,
    this.db,
  });

  // ignore: missing_return
  static Future<Backend> init() async {
    try {
      logger.logDebug('Initializing backend');
      final dbService = HiveCache();
      final ThemeData currentTheme = await JuntoThemesProvider.initialize();
      final JuntoHttp client = JuntoHttp(httpClient: IOClient());
      final AuthenticationService authService =
          AuthenticationServiceCentralized(client, dbService);
      final UserService userService = UserServiceCentralized(client);
      final ExpressionService expressionService =
          ExpressionServiceCentralized(client);
      final GroupService groupService = GroupServiceCentralized(client);
      final SearchService searchService = SearchServiceCentralized(client);
      final NotificationService notificationService =
          NotificationServiceImpl(client);
      final notificationRepo = NotificationRepo(notificationService, dbService);
      final UserRepo userRepo = UserRepo(
        userService,
        notificationRepo,
        dbService,
      );
      return Backend._(
        searchRepo: SearchRepo(searchService),
        authRepo: AuthRepo(authService, userRepo, expressionService),
        userRepo: userRepo,
        collectiveProvider: CollectiveProviderCentralized(client),
        groupsProvider: GroupRepo(groupService, userService),
        expressionRepo: ExpressionRepo(expressionService, dbService),
        currentTheme: currentTheme,
        notificationRepo: notificationRepo,
        appRepo: AppRepo(),
        db: dbService,
      );
    } catch (e, s) {
      logger.logException(e, s);
    }
  }

  static Future<Backend> mocked() async {
    final AuthenticationService authService = MockAuth();
    final UserService userService = MockUserService();
    final ExpressionService expressionService = MockExpressionService();
    final GroupService groupService = MockSphere();
    final SearchService searchService = MockSearch();
    return Backend._(
        authRepo: AuthRepo(authService, null, expressionService),
        userRepo: UserRepo(userService, null, null),
        collectiveProvider: null,
        groupsProvider: GroupRepo(groupService, userService),
        //TODO(Nash): MockDB
        expressionRepo: ExpressionRepo(expressionService, null),
        searchRepo: SearchRepo(searchService),
        currentTheme: JuntoThemes().aqueous,
        appRepo: AppRepo(),
        db: null);
  }

  final SearchRepo searchRepo;
  final AuthRepo authRepo;
  final UserRepo userRepo;
  final CollectiveService collectiveProvider;
  final GroupRepo groupsProvider;
  final ExpressionRepo expressionRepo;
  final NotificationRepo notificationRepo;
  final ThemeData currentTheme;
  final AppRepo appRepo;
  final LocalCache db;
}
