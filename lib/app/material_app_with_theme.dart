import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
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

class MaterialAppWithTheme extends StatefulWidget {
  @override
  _MaterialAppWithThemeState createState() => _MaterialAppWithThemeState();
}

class _MaterialAppWithThemeState extends State<MaterialAppWithTheme>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      UserData userProfile =
          Provider.of<UserDataProvider>(context, listen: false).userProfile;
      print(userProfile);
      if (userProfile == null) {
        try {
          context.bloc<AuthBloc>().add(LogoutEvent());
          Navigator.pushAndRemoveUntil(
            context,
            Welcome.route(),
            (route) => route.settings.name == "/",
          );
        } catch (e) {
          logger.logException(e);
        }
      }
    }
  }

  @override
  void dispose() {
    Hive.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(
      builder: (context, theme, _) {
        return MaterialApp(
          home: HomePage(),
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppBlocState>(
      builder: (context, state) {
        if (state is SupportedVersion) {
          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) => Stack(
              children: <Widget>[
                BackgroundTheme(),
                AnimatedSwitcher(
                  duration: kThemeAnimationDuration,
                  child: state.map(
                    loading: (_) => HomeLoadingPage(),
                    agreementsRequired: (_) => SignUpAgreements(),
                    authenticated: (_) => HomePageContent(),
                    unauthenticated: (_) => const Welcome(),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is UnsupportedState) {
          return UpdateApp();
        }
        return HomeLoadingPage();
      },
    );
  }
}

class HomePageContent extends StatelessWidget {
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
