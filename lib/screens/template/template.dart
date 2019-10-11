import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/providers/provider.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/screens/collective/filter_fab.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/perspectives.dart';
import 'package:junto_beta_mobile/screens/den/den.dart';
import 'package:junto_beta_mobile/screens/den/den_drawer/den_drawer.dart';
import 'package:junto_beta_mobile/screens/packs/packs.dart';
import 'package:junto_beta_mobile/screens/spheres/spheres.dart';
import 'package:junto_beta_mobile/widgets/appbar.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
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
      Scaffold(appBar: AppBar(), body: Center(child: Text('yo'))),
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
        return JuntoSpheres(
          userProfile: profile,
        );
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

        if (_hideFABController.offset != 0.0) {
          _hideFABController.animateTo(
            0.0,
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 200),
          );
        }

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
          _appbarTitle = 'sunyata';
          // _appbarTitle = profile?.username ?? 'Junto';
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
      builder: (BuildContext context) => Container(
        color: const Color(0xff737373),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 60,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffeeeeee),
                          width: .75,
                        ),
                      ),
                    ),
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
                        hintText: 'Filter by channel',
                        hintStyle: TextStyle(
                            color: Color(0xff999999),
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      cursorColor: const Color(0xff333333),
                      cursorWidth: 2,
                      maxLines: null,
                      style: const TextStyle(
                          color: Color(0xff333333),
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                      maxLength: 80,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  Container(
                    child: Icon(Icons.add, size: 20),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Update the list of channels in state
  //ignore: unused_element
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
  //ignore: unused_element
  void _removeChannel(StateSetter updateState, String channel) {
    updateState(
      () {
        _channels.remove(channel);
      },
    );
  }
}
