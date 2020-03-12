import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/collective_actions.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/widgets/appbar/collective_appbar.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/drawer/filter_drawer_content.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/zoom_scaffold.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This class is a collective screen
class JuntoCollective extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return JuntoCollective();
      },
    );
  }

  @override
  State<StatefulWidget> createState() => JuntoCollectiveState();
}

class JuntoCollectiveState extends State<JuntoCollective>
    with HideFab, SingleTickerProviderStateMixin {
  // Global key to uniquely identify Junto Collective
  final GlobalKey<ScaffoldState> _juntoCollectiveKey =
      GlobalKey<ScaffoldState>();

  final GlobalKey<JuntoFilterDrawerState> _filterDrawerKey =
      GlobalKey<JuntoFilterDrawerState>();

  // Completer which controls expressions querying.
  final ValueNotifier<Future<QueryResults<ExpressionResponse>>>
      _expressionCompleter =
      ValueNotifier<Future<QueryResults<ExpressionResponse>>>(null);

  ExpressionRepo _expressionProvider;

  String _userAddress;
  UserData _userProfile;

  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);
  ScrollController _collectiveController;
  String _appbarTitle = 'JUNTO';
  final List<String> _channels = <String>[];
  ValueNotifier<bool> actionsVisible = ValueNotifier<bool>(false);
  bool twoColumnView = true;

  MenuController menuController;

  @override
  void initState() {
    super.initState();
    _collectiveController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _collectiveController.addListener(_onScrollingHasChanged);
      if (_collectiveController.hasClients)
        _collectiveController.position.isScrollingNotifier.addListener(
          _onScrollingHasChanged,
        );
    });
    getUserInformation();

    menuController = MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshData();
  }

  Future<void> refreshData() async {
    _expressionProvider = Provider.of<ExpressionRepo>(context, listen: false);
    _expressionCompleter.value = getCollectiveExpressions(
      contextType: 'Collective',
      paginationPos: 0,
    );
  }

  void _onScrollingHasChanged() {
    super.hideFabOnScroll(_collectiveController, _isVisible);
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData = jsonDecode(
      prefs.getString('user_data'),
    );

    setState(() {
      _userAddress = prefs.getString('user_id');
      _userProfile = UserData.fromMap(decodedUserData);
      if (prefs.getBool('two-column-view') != null) {
        twoColumnView = prefs.getBool('two-column-view');
      }
    });
  }

  Future<QueryResults<ExpressionResponse>> getCollectiveExpressions({
    int dos,
    String contextType,
    String contextString,
    List<String> channels,
    int paginationPos = 0,
  }) async {
    Map<String, dynamic> _params;
    if (contextType == 'Dos' && dos != -1) {
      _params = <String, String>{
        'context_type': contextType,
        'pagination_position': paginationPos.toString(),
        'dos': dos.toString(),
      };
    } else if (contextType == 'ConnectPerspective') {
      _params = <String, String>{
        'context_type': contextType,
        'context': _userProfile.connectionPerspective.address,
        'pagination_position': paginationPos.toString(),
        if (_channels.isNotEmpty) 'channels[0]': _channels[0]
      };
    } else {
      _params = <String, String>{
        'context_type': contextType,
        'context': contextString,
        'pagination_position': paginationPos.toString(),
        if (_channels.isNotEmpty) 'channels[0]': _channels[0]
      };
    }
    try {
      return await _expressionProvider.getCollectiveExpressions(_params);
    } on JuntoException catch (error) {
      if (error.errorCode == 401) {
        Navigator.of(context).pushReplacement(Welcome.route());
      }
      return null;
    }
  }

  void _resetChannels() {
    setState(() {
      _channels.clear();
    });
    _expressionCompleter.value = getCollectiveExpressions(
        contextType: 'Collective', paginationPos: 0, channels: _channels);
    Navigator.pop(context);
  }

  Future<void> _switchColumnView(String columnType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (columnType == 'two') {
        twoColumnView = true;
        prefs.setBool('two-column-view', true);
      } else if (columnType == 'single') {
        twoColumnView = false;
        prefs.setBool('two-column-view', false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _collectiveController.removeListener(_onScrollingHasChanged);
    _collectiveController.dispose();
    menuController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCollectivePage(context);
  }

  // Renders the collective screen within a scaffold.
  Widget _buildCollectivePage(BuildContext context) {
    return ChangeNotifierProvider<MenuController>.value(
      value: menuController,
      child: ZoomScaffold(
        menuScreen: JuntoDrawer(),
        contentScreen: Layout(
          contentBuilder: (BuildContext context) => GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              //on swiping from right to left
              // if (details.delta.dx < 6) {
              //   Provider.of<MenuController>(context, listen: false).open();
              // }
            },
            child: JuntoFilterDrawer(
              key: _filterDrawerKey,
              drawer: FilterDrawerContent(
                filterByChannel: _filterByChannel,
                channels: _channels,
                resetChannels: _resetChannels,
              ),
              scaffold: Scaffold(
                resizeToAvoidBottomInset: false,
                key: _juntoCollectiveKey,
                floatingActionButton: ValueListenableBuilder<bool>(
                  valueListenable: _isVisible,
                  builder: (BuildContext context, bool visible, Widget child) {
                    return AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: visible ? 1.0 : 0.0,
                        child: child);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: actionsVisible,
                      builder: (BuildContext context, bool value, _) {
                        return BottomNav(
                          screen: 'collective',
                          userProfile: _userProfile,
                          actionsVisible: value,
                          onTap: () {
                            if (value) {
                              actionsVisible.value = false;
                            } else {
                              actionsVisible.value = true;
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                // dynamically render body
                body: ValueListenableBuilder<bool>(
                    valueListenable: actionsVisible,
                    builder: (BuildContext context, bool value, _) {
                      return Stack(
                        children: <Widget>[
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: value ? 0.0 : 1.0,
                            child: Visibility(
                              visible: !value,
                              child: _buildPerspectiveFeed(),
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: value ? 1.0 : 0.0,
                            child: Visibility(
                              visible: value,
                              child: JuntoCollectiveActions(
                                userProfile: _userProfile,
                                changePerspective: _changePerspective,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerspectiveFeed() {
    return RefreshIndicator(
      onRefresh: refreshData,
      child: ValueListenableBuilder<Future<QueryResults<ExpressionResponse>>>(
        valueListenable: _expressionCompleter,
        builder: (
          BuildContext context,
          Future<QueryResults<ExpressionResponse>> value,
          _,
        ) {
          return FutureBuilder<QueryResults<ExpressionResponse>>(
            future: value,
            builder: (
              BuildContext context,
              AsyncSnapshot<QueryResults<ExpressionResponse>> snapshot,
            ) {
              if (snapshot.hasError) {
                print('Error: ${snapshot.error}');
                return const Center(
                  child: Text('hmm, something is up with our servers'),
                );
              }
              if (snapshot.hasData) {
                return CustomScrollView(
                  controller: _collectiveController,
                  slivers: <Widget>[
                    SliverPersistentHeader(
                      delegate: CollectiveAppBar(
                          expandedHeight: 135,
                          appbarTitle: _appbarTitle,
                          openFilterDrawer: _toggleFilterDrawer,
                          twoColumnView: twoColumnView,
                          switchColumnView: _switchColumnView),
                      pinned: false,
                      floating: true,
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(<Widget>[
                        AnimatedCrossFade(
                          crossFadeState: twoColumnView
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 200),
                          firstChild: TwoColumnSliverListView(
                            userAddress: _userAddress,
                            data: snapshot.data.results,
                          ),
                          secondChild: SingleColumnSliverListView(
                            userAddress: _userAddress,
                            data: snapshot.data.results,
                          ),
                        )
                      ]),
                    )
                  ],
                );
              }
              return Center(
                child: JuntoProgressIndicator(),
              );
            },
          );
        },
      ),
    );
  }

  void _toggleFilterDrawer() {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
    _filterDrawerKey.currentState.toggle();
  }

  void _filterByChannel(Channel channel) {
    setState(() {
      if (_channels.isEmpty) {
        _channels.add(channel.name);
      } else {
        _channels[0] = channel.name;
      }
    });
    actionsVisible.value = false;
    _expressionCompleter.value = getCollectiveExpressions(
      contextType: 'Collective',
      paginationPos: 0,
      channels: _channels,
    );
  }

// Switch between perspectives; used in perspectives side drawer.
  void _changePerspective(PerspectiveModel perspective) {
    if (perspective.name == 'JUNTO') {
      setState(() {
        _appbarTitle = 'JUNTO';
      });
      _expressionCompleter.value = getCollectiveExpressions(
          contextType: 'Collective', paginationPos: 0, channels: _channels);
    } else if (perspective.name == 'Connections') {
      setState(() {
        _appbarTitle = 'Connections';
      });
      _expressionCompleter.value = getCollectiveExpressions(
        paginationPos: 0,
        contextType: 'ConnectPerspective',
        dos: 0,
      );
    } else {
      setState(() {
        if (perspective.name ==
            _userProfile.user.name + "'s Follow Perspective") {
          _appbarTitle = 'Subscriptions';
        } else {
          _appbarTitle = perspective.name;
        }
      });
      _expressionCompleter.value = getCollectiveExpressions(
        paginationPos: 0,
        contextString: perspective.address,
        contextType: 'FollowPerspective',
        dos: null,
        channels: _channels,
      );
    }
    actionsVisible.value = false;
  }
}
