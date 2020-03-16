import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/collective_actions.dart';
import 'package:junto_beta_mobile/screens/collective/collective_fab.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/widgets/drawer/filter_drawer_content.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
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
  final ValueNotifier<String> _appbarTitle = ValueNotifier<String>('JUNTO');
  final List<String> _channels = <String>[];
  bool _actionsVisible = false;
  bool twoColumnView = true;

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
    _addPostFrameCallback();
    getUserInformation();
  }

  @override
  void dispose() {
    _collectiveController.removeListener(_onScrollingHasChanged);
    _collectiveController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshData();
  }

  void _addPostFrameCallback() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _collectiveController.addListener(_onScrollingHasChanged);
      if (_collectiveController.hasClients)
        _collectiveController.position.isScrollingNotifier.addListener(
          _onScrollingHasChanged,
        );
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JuntoFilterDrawer(
        key: _filterDrawerKey,
        leftDrawer: FilterDrawerContent(
          filterByChannel: _filterByChannel,
          channels: _channels,
          resetChannels: _resetChannels,
        ),
        rightMenu: JuntoDrawer(),
        scaffold: Scaffold(
          key: _juntoCollectiveKey,
          floatingActionButton: CollectiveActionButton(
            userProfile: _userProfile,
            isVisible: _isVisible,
            actionsVisible: _actionsVisible,
            onTap: () {
              setState(() {
                if (_actionsVisible) {
                  _actionsVisible = false;
                } else {
                  _actionsVisible = true;
                }
              });
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: Stack(
            children: <Widget>[
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _actionsVisible ? 0.0 : 1.0,
                child: ExpressionFeed(
                  refreshData: refreshData,
                  expressionCompleter: _expressionCompleter,
                  collectiveController: _collectiveController,
                  appbarTitle: _appbarTitle,
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _actionsVisible ? 1.0 : 0.0,
                child: Visibility(
                  visible: _actionsVisible,
                  child: JuntoCollectiveActions(
                    userProfile: _userProfile,
                    changePerspective: _changePerspective,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _filterByChannel(Channel channel) {
    setState(() {
      if (_channels.isEmpty) {
        _channels.add(channel.name);
      } else {
        _channels.first = channel.name;
      }
    });
    _expressionCompleter.value = getCollectiveExpressions(
      contextType: 'Collective',
      paginationPos: 0,
      channels: _channels,
    );
  }

// Switch between perspectives; used in perspectives side drawer.
  void _changePerspective(PerspectiveModel perspective) {
    if (perspective.name == 'JUNTO') {
      _appbarTitle.value = 'JUNTO';
      _expressionCompleter.value = getCollectiveExpressions(
          contextType: 'Collective', paginationPos: 0, channels: _channels);
    } else if (perspective.name == 'Connections') {
      _appbarTitle.value = 'Connections';
      _expressionCompleter.value = getCollectiveExpressions(
        paginationPos: 0,
        contextType: 'ConnectPerspective',
        dos: 0,
      );
    } else {
      setState(() {
        if (perspective.name ==
            _userProfile.user.name + "'s Follow Perspective") {
          _appbarTitle.value = 'Subscriptions';
        } else {
          _appbarTitle.value = perspective.name;
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
    setState(() {
      _actionsVisible = false;
    });
  }
}
