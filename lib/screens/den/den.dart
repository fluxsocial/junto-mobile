import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/filters/bloc/channel_filtering_bloc.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/den/bloc/den_bloc.dart';
import 'package:junto_beta_mobile/screens/den/den_sliver_appbar.dart';
import 'package:junto_beta_mobile/widgets/appbar/den_appbar.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/user_expressions.dart';
import 'package:junto_beta_mobile/widgets/drawer/filter_drawer_content.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/about_member.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';

/// Displays the user's DEN or "profile screen"
class JuntoDen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => JuntoDenState();
}

class JuntoDenState extends State<JuntoDen>
    with HideFab, TickerProviderStateMixin {
  bool showComments = false;

  ScrollController _denController;
  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _denController = ScrollController();
  }

  @override
  void dispose() {
    _denController.dispose();
    super.dispose();
  }

  Widget _buildBody(UserData user) {
    return NestedScrollView(
      controller: _denController,
      physics: const ClampingScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverPersistentHeader(
            delegate: DenAppbar(
              expandedHeight: MediaQuery.of(context).size.height * .1,
              heading: user.user.username,
            ),
            floating: true,
            pinned: false,
          ),
          JuntoDenSliverAppbar(
            profile: user,
          ),
        ];
      },
      body: UserExpressions(
        privacy: 'Public',
        userProfile: user.user,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (BuildContext context, UserDataProvider user, Widget child) {
        return FeatureDiscovery(
          child: NotificationListener<ScrollUpdateNotification>(
            onNotification: (value) => hideOrShowFab(value, _isVisible),
            child: MultiBlocProvider(
              providers: [
                BlocProvider<DenBloc>(
                  create: (context) => DenBloc(
                      Provider.of<UserRepo>(context, listen: false),
                      Provider.of<UserDataProvider>(context, listen: false))
                    ..add(LoadDen(user.userAddress)),
                ),
                BlocProvider<ChannelFilteringBloc>(
                  create: (ctx) => ChannelFilteringBloc(
                    RepositoryProvider.of<SearchRepo>(ctx),
                    (value) => BlocProvider.of<DenBloc>(ctx).add(
                      LoadDen(
                        user.userAddress,
                        channels: value != null ? [value.name] : null,
                      ),
                    ),
                  ),
                ),
              ],
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: JuntoFilterDrawer(
                  leftDrawer: const FilterDrawerContent(
                    ExpressionContextType.Collective,
                  ),
                  rightMenu: JuntoDrawer(),
                  scaffold: Scaffold(
                    floatingActionButton:
                        DenActionButton(isVisible: _isVisible, user: user),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,
                    body: _buildBody(user.userProfile),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DenActionButton extends StatelessWidget {
  const DenActionButton({
    Key key,
    @required this.isVisible,
    @required this.user,
  }) : super(key: key);

  final ValueNotifier<bool> isVisible;
  final UserDataProvider user;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isVisible,
      builder: (context, visible, child) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: visible ? 1.0 : 0.0,
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: BottomNav(
          actionsVisible: false,
          onLeftButtonTap: () {
            // open about page
            Navigator.push(
              context,
              CupertinoPageRoute<dynamic>(
                builder: (BuildContext context) =>
                    AboutMember(profile: user.userProfile),
              ),
            );
          },
          source: Screen.den,
        ),
      ),
    );
  }
}
