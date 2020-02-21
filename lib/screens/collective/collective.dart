import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/collective_actions.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/widgets/appbar/collective_appbar.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview.dart';
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

  // Completer which controls expressions querying.
  final ValueNotifier<Future<QueryResults<CentralizedExpressionResponse>>>
      _expressionCompleter =
      ValueNotifier<Future<QueryResults<CentralizedExpressionResponse>>>(null);

  ExpressionRepo _expressionProvider;

  String _userAddress;
  UserData _userProfile;

  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);
  ScrollController _collectiveController;
  String _appbarTitle = 'JUNTO';
  bool _showDegrees = true;
  String currentDegree = 'oo';
  final List<String> _channels = <String>[];
  ValueNotifier<bool> actionsVisible = ValueNotifier<bool>(false);

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
    final Map<String, dynamic> decodedUserData =
        jsonDecode(prefs.getString('user_data'));
    setState(() {
      _userAddress = prefs.getString('user_id');
      _userProfile = UserData.fromMap(decodedUserData);
    });
  }

  Future<QueryResults<CentralizedExpressionResponse>> getCollectiveExpressions({
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

  @override
  void dispose() {
    super.dispose();
    _collectiveController.removeListener(_onScrollingHasChanged);
    _collectiveController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCollectivePage(context);
  }

  // Renders the collective screen within a scaffold.
  Widget _buildCollectivePage(BuildContext context) {
    return Scaffold(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      endDrawer: const JuntoDrawer(
        screen: 'Collective',
        icon: CustomIcons.collective,
      ),
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
                    //ignore:avoid_bool_literals_in_conditional_expressions
                    visible: value ? false : true,
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
                      filterByChannel: _filterByChannel,
                      currentPerspective: _appbarTitle,
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _buildPerspectiveFeed() {
    return RefreshIndicator(
      onRefresh: refreshData,
      child: ValueListenableBuilder<
              Future<QueryResults<CentralizedExpressionResponse>>>(
          valueListenable: _expressionCompleter,
          builder: (
            BuildContext context,
            Future<QueryResults<CentralizedExpressionResponse>> value,
            _,
          ) {
            return FutureBuilder<QueryResults<CentralizedExpressionResponse>>(
              future: value,
              builder: (
                BuildContext context,
                AsyncSnapshot<QueryResults<CentralizedExpressionResponse>>
                    snapshot,
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
                          expandedHeight: _showDegrees == true ? 135 : 85,
                          degrees: _showDegrees,
                          currentDegree: currentDegree,
                          switchDegree: _switchDegree,
                          appbarTitle: _appbarTitle,
                          openPerspectivesDrawer: () {},
                        ),
                        pinned: false,
                        floating: true,
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          <Widget>[
                            Container(
                              color: Theme.of(context).backgroundColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * .5,
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      left: 10,
                                      right: 5,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        for (int index = 0;
                                            index <
                                                snapshot.data.results.length +
                                                    1;
                                            index++)
                                          if (index ==
                                              snapshot.data.results.length)
                                            const SizedBox()
                                          else if (index.isEven)
                                            ExpressionPreview(
                                              expression:
                                                  snapshot.data.results[index],
                                              userAddress: _userAddress,
                                            )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * .5,
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      left: 5,
                                      right: 10,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        for (int index = 0;
                                            index <
                                                snapshot.data.results.length +
                                                    1;
                                            index++)
                                          if (index ==
                                              snapshot.data.results.length)
                                            const SizedBox()
                                          else if (index.isOdd)
                                            ExpressionPreview(
                                              expression:
                                                  snapshot.data.results[index],
                                              userAddress: _userAddress,
                                            )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }
                return Center(
                  child: JuntoProgressIndicator(),
                );
              },
            );
          }),
    );
  }

// switch between degrees of separation
  void _switchDegree({String degreeName, int degreeNumber}) {
    String _contextType;

    if (degreeNumber == -1) {
      _contextType = 'Collective';
    } else if (degreeNumber == 0) {
      _contextType = 'ConnectPerspective';
    } else {
      _contextType = 'Dos';
    }
    _expressionCompleter.value = getCollectiveExpressions(
      paginationPos: 0,
      contextType: _contextType,
      dos: degreeNumber,
    );

    setState(() {
      _showDegrees = true;
      currentDegree = degreeName;
    });
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
        contextType: 'Collective', paginationPos: 0, channels: _channels);
  }

// Switch between perspectives; used in perspectives side drawer.
  void _changePerspective(CentralizedPerspective perspective) {
    if (perspective.name == 'JUNTO') {
      setState(() {
        _showDegrees = true;
        _appbarTitle = 'JUNTO';
      });
      _expressionCompleter.value = getCollectiveExpressions(
          contextType: 'Collective', paginationPos: 0, channels: _channels);
    } else {
      setState(() {
        _showDegrees = false;
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
