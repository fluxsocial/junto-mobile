import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/screens/lotus/lotus.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_navigation_observer.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';
import 'package:junto_beta_mobile/screens/welcome/bloc/bloc.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_agreement.dart';
import 'package:junto_beta_mobile/screens/welcome/unsupported_screen.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:junto_beta_mobile/widgets/background/background_theme.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/app/bloc/app_bloc.dart';
import 'package:provider/provider.dart';

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(
      builder: (context, theme, _) {
        return MaterialApp(
          home: BlocBuilder<AppBloc, AppBlocState>(
            builder: (context, state) {
              if (state is SupportedVersion) {
                return HomePage();
              } else if (state is UnsupportedState) {
                return UpdateApp();
              } else {
                return HomeLoadingPage();
              }
            },
          ),
          title: 'JUNTO Alpha',
          debugShowCheckedModeBanner: false,
          theme: theme.currentTheme,
          navigatorObservers: [
            NotificationNavigationObserver(
                Provider.of<NotificationsHandler>(context)),
          ],
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // Replace later with S.supportedLocales
          supportedLocales: [
            Locale('en'),
          ],
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  Widget _buildChildFor({@required AuthState state}) {
    if (state is AuthLoading) {
      return HomeLoadingPage();
    } else if (state is AuthAgreementsRequired) {
      return SignUpAgreements();
    } else if (state is AuthAuthenticated) {
      return HomePageContent();
    } else if (state is AuthUnauthenticated) {
      return Welcome();
    } else {
      return Welcome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Stack(
          children: <Widget>[
            BackgroundTheme(),
            AnimatedSwitcher(
              duration: kThemeAnimationDuration,
              child: _buildChildFor(state: state),
            ),
          ],
        );
      },
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return HomePageContentState();
  }
}

class HomePageContentState extends State<HomePageContent>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkServerVersion();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    UserData userProfile =
        Provider.of<UserDataProvider>(context, listen: false).userProfile;
    if (userProfile == null) {
      context.bloc<AuthBloc>().add(RefreshUser());
    }
    if (state == AppLifecycleState.resumed) {
      _checkServerVersion();
    }
  }

  void _checkServerVersion() {
    context.bloc<AppBloc>().add(CheckServerVersion());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: const JuntoLotus(
        address: null,
        expressionContext: ExpressionContext.Collective,
        source: null,
      ),
    );
  }
}

class HomeLoadingPage extends StatelessWidget {
  const HomeLoadingPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          BackgroundTheme(),
          JuntoProgressIndicator(),
        ],
      ),
    );
  }
}
