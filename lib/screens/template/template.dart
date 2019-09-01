import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/components/appbar/appbar.dart';
import 'package:junto_beta_mobile/components/bottom_nav/bottom_nav.dart';
import 'package:junto_beta_mobile/components/utils/custom_scroll_behaviour.dart';
import 'package:junto_beta_mobile/components/utils/hide_fab.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/screens/collective/filter_fab/filter_fab.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/perspectives.dart';
import 'package:junto_beta_mobile/screens/den/den.dart';
import 'package:junto_beta_mobile/screens/packs/packs.dart';
import 'package:junto_beta_mobile/screens/spheres/spheres.dart';
import 'package:junto_beta_mobile/typography/palette.dart';

// This class is a template screen that contains the navbar, bottom bar,
// and screen (collective, spheres, pack, etc) depending on condition.
class JuntoTemplate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => JuntoTemplateState();
}

class JuntoTemplateState extends State<JuntoTemplate> with HideFab {
  final GlobalKey<ScaffoldState> _juntoTemplateKey = GlobalKey<ScaffoldState>();

  // Default values for collective screen / JUNTO perspective - change dynamically.
  String _currentScreen = 'collective';

  //ignore:unused_field
  String _currentPerspective = 'JUNTO';
  String _appbarTitle = 'JUNTO';

  ValueNotifier<int> _bottomNavIndex;

  //
  final List<String> _channels = <String>[];
  TextEditingController _channelController;

  // Controller for PageView
  PageController _controller;

  // Controller for scroll
  ScrollController _hideFABController;
  ValueNotifier<bool> _isVisible;

  @override
  void initState() {
    super.initState();
    _hideFABController = ScrollController();
    _bottomNavIndex = ValueNotifier<int>(0);
    _channelController = TextEditingController();
    _controller = PageController(initialPage: 0);
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
  void dispose() {
    _hideFABController.removeListener(_onScrollingHasChanged);
    _hideFABController.dispose();
    _controller.dispose();
    _channelController.dispose();
    super.dispose();
  }

  /// Opens the `Perspective` screen if the user swipes right.
  /// Animates the PageView to the next page if the user swipes left.
  void _onDragUpdate(DragUpdateDetails details) {
    if (!details.primaryDelta.isNegative) {
      _juntoTemplateKey.currentState.openDrawer();
    } else {
      _controller.animateToPage(
        1,
        duration: kTabScrollDuration,
        curve: Curves.decelerate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _juntoTemplateKey,
      backgroundColor: Colors.white,
      appBar: JuntoAppBar(
        juntoAppBarTitle: _appbarTitle,
        navNotifications: _navNotifications,
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
              ),
            )
          : null,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: PlainScrollBehaviour(),
          child: PageView(
            physics: const ClampingScrollPhysics(),
            controller: _controller,
            onPageChanged: (int index) {
              _isVisible.value = true;
              if (index == 0) {
                _switchScreen('collective');
              } else if (index == 1) {
                _switchScreen('spheres');
              } else if (index == 2) {
                _switchScreen('packs');
              } else if (index == 3) {
                _switchScreen('den');
              }
            },
            children: <Widget>[
              GestureDetector(
                onHorizontalDragUpdate: _onDragUpdate,
                child: JuntoCollective(
                  controller: _hideFABController,
                  currentPerspective: _currentPerspective,
                ),
              ),
              JuntoSpheres(),
              JuntoPacks(),
              JuntoDen()
            ],
          ),
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _bottomNavIndex,
        builder: (BuildContext context, int index, _) {
          return BottomNav(
            currentIndex: index,
            setIndex: _setBottomIndex,
          );
        },
      ),
    );
  }

  // Set the bottom navbar index; used when bottom nav icon is pressed.
  void _setBottomIndex(int x) {
    _bottomNavIndex.value = x;
    _controller.jumpToPage(x);
    if (x == 0) {
      _hideFABController.animateTo(
        0.0,
        curve: Curves.decelerate,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  // Switch between perspectives; used in perspectives side drawer.
  void _changePerspective(String perspective) {
    setState(
      () {
        _currentPerspective = perspective;
        _appbarTitle = perspective;

        // re render feed
      },
    );
  }

  // Switch between screens within PageView
  void _switchScreen(String screen) {
    if (screen == 'collective') {
      setState(() {
        _currentScreen = 'collective';
        _appbarTitle = 'JUNTO';
        _currentPerspective = 'JUNTO';
        _bottomNavIndex.value = 0;
      });
    } else if (screen == 'spheres') {
      setState(() {
        _currentScreen = 'spheres';
        _appbarTitle = 'SPHERES';
        _bottomNavIndex.value = 1;
      });
    } else if (screen == 'packs') {
      setState(() {
        _currentScreen = 'packs';
        _appbarTitle = 'PACKS';
        _bottomNavIndex.value = 2;
      });
    } else if (screen == 'den') {
      setState(() {
        _currentScreen = 'den';
        _appbarTitle = 'sunyata';
        _bottomNavIndex.value = 3;
      });
    }
  }

  // Navigate to Notifications screen
  void _navNotifications() {
    Navigator.pushNamed(context, '/notifications');
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '# filter by channel',
                            ),
                            cursorColor: JuntoPalette.juntoGrey,
                            cursorWidth: 2,
                            style: const TextStyle(
                              color: Color(0xff333333),
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
                                color: Color(0xff333333),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xff333333),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
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
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: const Color(0xff333333),
                                            width: 1,
                                          ),
                                        ),
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
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
