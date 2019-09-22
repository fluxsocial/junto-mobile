import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/components/appbar/appbar.dart';
import 'package:junto_beta_mobile/components/bottom_nav/bottom_nav.dart';
import 'package:junto_beta_mobile/components/utils/hide_fab.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/providers/provider.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/screens/collective/filter_fab.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/perspectives.dart';
import 'package:junto_beta_mobile/screens/den/den.dart';
import 'package:junto_beta_mobile/screens/den/den_drawer/den_drawer.dart';
import 'package:junto_beta_mobile/screens/packs/packs.dart';
import 'package:junto_beta_mobile/screens/spheres/spheres.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';
import 'package:provider/provider.dart';

// This class is a template screen that contains the navbar, bottom bar,
// and screen (collective, spheres, pack, etc) depending on condition.
class JuntoTemplate extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return JuntoTemplate();
      },
    );
  }

  @override
  State<StatefulWidget> createState() => JuntoTemplateState();
}

class JuntoTemplateState extends State<JuntoTemplate> with HideFab {
  final GlobalKey<ScaffoldState> _juntoTemplateKey = GlobalKey<ScaffoldState>();

  // Default values for collective screen / JUNTO perspective - change dynamically.
  String _currentScreen = 'collective';
  String _currentPerspective = 'JUNTO';
  String _appbarTitle = 'JUNTO';

  ValueNotifier<int> _bottomNavIndex;

  //
  final List<String> _channels = <String>[];
  TextEditingController _channelController;

  // Controller for scroll
  ScrollController _hideFABController;
  ValueNotifier<bool> _isVisible;
  UserProfile profile;

  @override
  void initState() {
    super.initState();
    _hideFABController = ScrollController();
    _bottomNavIndex = ValueNotifier<int>(0);
    _channelController = TextEditingController();
    _isVisible = ValueNotifier<bool>(true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hideFABController.addListener(_onScrollingHasChanged);
      _hideFABController.position.isScrollingNotifier.addListener(
        _onScrollingHasChanged,
      );
    });
  }

  void _onScrollingHasChanged() {
    super.hideFabOnScroll(_hideFABController, _isVisible);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _retrieveUserInfo();
  }

  Future<void> _retrieveUserInfo() async {
    final UserProvider _userProvider = Provider.of<UserProvider>(context);
    try {
      final UserProfile _profile = await _userProvider.readLocalUser();
      setState(() {
        profile = _profile;
      });
    } catch (error) {
      debugPrint('Error occured in _retrieveUserInfo: $error');
    }
  }

  @override
  void dispose() {
    _hideFABController.removeListener(_onScrollingHasChanged);
    _hideFABController.dispose();
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Scaffold(
        key: _juntoTemplateKey,
        backgroundColor: Colors.white,
        appBar: JuntoAppBar(
          juntoAppBarTitle: _appbarTitle,
        ),
        floatingActionButton: _currentScreen == 'collective'
            ? CollectiveFilterFAB(
                isVisible: _isVisible,
                toggleFilter: _buildFilterChannelModal,
              )
            : null,
        // only enable drawer if current screen is collective
        drawer: _currentScreen == 'collective'
            ? WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: Perspectives(
                  changePerspective: _changePerspective,
                  profile: profile,
                ),
              )
            : null,
        // only enable end drawer if current screen is den
        endDrawer: _currentScreen == 'den'
            ? WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: DenDrawer())
            : null,

        // dynamically render body
        body: _renderBody(),

        bottomNavigationBar: ValueListenableBuilder<int>(
          valueListenable: _bottomNavIndex,
          builder: (BuildContext context, int index, _) {
            return BottomNav(
              currentIndex: index,
              setIndex: _switchScreen,
            );
          },
        ),
      ),
      // Container(
      //   color: Color(0xff111111),
      //   child: Center(
      //     child: Container(
      //       width: MediaQuery.of(context).size.width,
      //       child: Image.asset('assets/images/junto-mobile__eric.png',
      //           fit: BoxFit.fitWidth),
      //     ),
      //   ),
      // ),
    ]);
  }

  // render main body of template; i.e. collective, spheres, packs, or den
  Widget _renderBody() {
    switch (_currentScreen) {
      case 'collective':
        return JuntoCollective(
            controller: _hideFABController,
            currentPerspective: _currentPerspective);
      case 'spheres':
        return JuntoSpheres();
      case 'packs':
        return JuntoPacks();
      case 'den':
        return JuntoDen();
    }
    return Container();
  }

  // switch screen and update appbar title
  void _switchScreen(int x) {
    _bottomNavIndex.value = x;

    switch (x) {
      case 0:
        setState(() {
          _currentScreen = 'collective';
          _appbarTitle = 'JUNTO';
        });
        break;
      case 1:
        setState(() {
          _currentScreen = 'spheres';
          _appbarTitle = 'SPHERES';
        });
        break;
      case 2:
        setState(() {
          _currentScreen = 'packs';
          _appbarTitle = 'PACKS';
        });
        break;
      case 3:
        setState(() {
          _currentScreen = 'den';
          _appbarTitle = profile?.username ?? 'Junto';
        });
        break;
    }
  }

  // Switch between perspectives; used in perspectives side drawer.
  void _changePerspective(String perspective) {
    setState(
      () {
        _currentPerspective = perspective;
        _appbarTitle = perspective;
      },
    );
  }

  // Build bottom modal to filter by channel
  void _buildFilterChannelModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // Use StatefulBuilder to pass state of CreateActions
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter state) {
            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: JuntoStyles.horizontalPadding),
              height: MediaQuery.of(context).size.height * .4,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * .75,
                          child: TextField(
                            controller: _channelController,
                            buildCounter: (
                              BuildContext context, {
                              int currentLength,
                              int maxLength,
                              bool isFocused,
                            }) =>
                                null,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '# filter by channel',
                            ),
                            cursorColor: JuntoPalette.juntoGrey,
                            cursorWidth: 2,
                            style: const TextStyle(
                              color: JuntoPalette.juntoGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            maxLength: 80,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: GestureDetector(
                            onTap: () {
                              // Update channels list in state until there are 3
                              _channels.length < 3
                                  ? _updateChannels(
                                      state,
                                      _channelController.text,
                                    )
                                  : _nullChannels();
                            },
                            child: const Text(
                              'add',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: JuntoPalette.juntoGrey,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: JuntoPalette.juntoGrey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: JuntoPalette.juntoFade, width: 1),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: _channels.isEmpty
                        ? const EdgeInsets.all(0)
                        : const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _channels.isEmpty
                            ? const SizedBox()
                            : Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: const Text(
                                  'DOUBLE TAP TO REMOVE CHANNEL',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                        Wrap(
                          runSpacing: 5,
                          alignment: WrapAlignment.start,
                          direction: Axis.horizontal,
                          children: _channels
                              .map(
                                (String channel) => GestureDetector(
                                  onDoubleTap: () {
                                    _removeChannel(state, channel);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: JuntoPalette.juntoGrey,
                                        width: 1,
                                      ),
                                    ),
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: JuntoStyles.horizontalPadding,
                                      vertical: 5,
                                    ),
                                    child: Text(
                                      channel,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Update the list of channels in state
  void _updateChannels(StateSetter updateState, String channel) {
    updateState(
      () {
        if (channel != '') {
          _channels.add(channel);
          print(_channels);
          _channelController.text = '';
        }
      },
    );
  }

  // Remove a channel from the list of channels in state
  void _removeChannel(StateSetter updateState, String channel) {
    updateState(
      () {
        _channels.remove(channel);
      },
    );
  }

  // Called when channels.length > x
  void _nullChannels() {
    return;
  }
}
