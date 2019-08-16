import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/components/appbar/appbar.dart';
import 'package:junto_beta_mobile/components/bottom_nav/bottom_nav.dart';
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
  State<StatefulWidget> createState() {
    return JuntoTemplateState();
  }
}

class JuntoTemplateState extends State<JuntoTemplate> {
  // Default values for collective screen / JUNTO perspective - change dynamically.
  var _currentScreen = 'collective';
  String _currentPerspective = 'JUNTO';
  String _appbarTitle = 'JUNTO';

  int _bottomNavIndex = 0;

  //
  List _channels = [];
  TextEditingController _channelController = TextEditingController();

  // Controller for PageView
  final controller = PageController(
    initialPage: 0,
  );

  // Controller for scroll
  ScrollController _hideFABController = ScrollController();
  bool _isVisible = true;

  @override
  void initState() {
    _hideFABController.addListener(
      () {
        if (_hideFABController.position.userScrollDirection ==
            ScrollDirection.idle) {
          setState(
            () {
              _isVisible = true;
            },
          );
        } else if (_hideFABController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          setState(
            () {
              _isVisible = false;
            },
          );
        } else if (_hideFABController.position.userScrollDirection ==
            ScrollDirection.forward) {
          setState(
            () {
              _isVisible = true;
            },
          );
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(45),
            child: JuntoAppBar(
              _appbarTitle,
              _navNotifications,
            ),
          ),
          floatingActionButton: _currentScreen == 'collective'
              ? CollectiveFilterFAB(
                  _isVisible,
                  _buildFilterChannelModal,
                )
              : null,
          drawer:
              // only enable drawer if current screen is collective
              _currentScreen == 'collective'
                  ? WillPopScope(
                      onWillPop: () async {
                        return false;
                      },
                      child: Perspectives(
                        _changePerspective,
                      ),
                    )
                  : null,
          body: PageView(
            controller: controller,
            onPageChanged: (int) {
              if (int == 0) {
                _switchScreen('collective');
              } else if (int == 1) {
                _switchScreen('spheres');
              } else if (int == 2) {
                _switchScreen('packs');
              } else if (int == 3) {
                _switchScreen('den');
              }
            },
            children: <Widget>[
              JuntoCollective(_hideFABController),
              JuntoSpheres(),
              JuntoPacks(),
              JuntoDen()
            ],
          ),
          bottomNavigationBar: BottomNav(
            _bottomNavIndex,
            _setBottomIndex,
          ),
        ),
      ],
    );
  }

  // Set the bottom navbar index; used when bottom nav icon is pressed.
  _setBottomIndex(x) {
    setState(() {
      _bottomNavIndex = x;
      controller.jumpToPage(x);
    });
  }

  // Switch between perspectives; used in perspectives side drawer.
  void _changePerspective(perspective) {
    setState(
      () {
        _currentPerspective = perspective;
        _appbarTitle = perspective;

        // re render feed
      },
    );
  }

  // Switch between screens within PageView
  _switchScreen(screen) {
    if (screen == 'collective') {
      setState(() {
        _currentScreen = 'collective';
        _appbarTitle = 'JUNTO';
        _bottomNavIndex = 0;
      });
    } else if (screen == 'spheres') {
      setState(() {
        _currentScreen = 'spheres';
        _appbarTitle = 'SPHERES';
        _bottomNavIndex = 1;
      });
    } else if (screen == 'packs') {
      setState(() {
        _currentScreen = 'packs';
        _appbarTitle = 'PACKS';
        _bottomNavIndex = 2;
      });
    } else if (screen == 'den') {
      setState(() {
        _currentScreen = 'den';
        _appbarTitle = 'DEN';
        _bottomNavIndex = 3;
      });
    }
  }

  // Navigate to Notifications screen
  _navNotifications() {
    Navigator.pushNamed(context, '/notifications');
  }

  // Build bottom modal to filter by channel
  _buildFilterChannelModal(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        // Use StatefulBuilder to pass state of CreateActions
        return StatefulBuilder(
          builder: (context, state) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(context).size.height * .4,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
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
                            style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            maxLength: 80,
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                            child: Text(
                              'add',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff333333),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xff333333), width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: _channels.length == 0
                        ? EdgeInsets.all(0)
                        : EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _channels.length == 0
                            ? SizedBox()
                            : Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Text(
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
                                (channel) => GestureDetector(
                                      onDoubleTap: () {
                                        _removeChannel(state, channel);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: Color(0xff333333),
                                            width: 1,
                                          ),
                                        ),
                                        margin: EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        child: Text(
                                          channel,
                                          style: TextStyle(
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
  _updateChannels(StateSetter updateState, channel) async {
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
  _removeChannel(StateSetter updateState, channel) async {
    updateState(
      () {
        _channels.remove(channel);
      },
    );
  }

  // Called when channels.length > x
  _nullChannels() {
    return;
  }
}
