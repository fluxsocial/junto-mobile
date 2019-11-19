import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives'
    '/create_perspective/create_perspective.dart' show SelectedUsers;
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:provider/provider.dart';

// Junto app bar used throughout the main screens. Rendered in JuntoTemplate.
class JuntoAppBar extends StatefulWidget implements PreferredSizeWidget {
  const JuntoAppBar({
    Key key,
    this.appContext,
    this.openPerspectivesDrawer,
    @required this.juntoAppBarTitle,
  }) : super(key: key);

  final String appContext;
  final Function openPerspectivesDrawer;
  final String juntoAppBarTitle;

  @override
  Size get preferredSize => const Size.fromHeight(48.0);

  @override
  _JuntoAppBarState createState() => _JuntoAppBarState();
}

class _JuntoAppBarState extends State<JuntoAppBar>
    with AddUserToList<UserProfile> {
  Timer debounceTimer;
  ValueNotifier<List<UserProfile>> queriedUsers =
      ValueNotifier<List<UserProfile>>(<UserProfile>[]);
  final ValueNotifier<SelectedUsers> _users = ValueNotifier<SelectedUsers>(
    SelectedUsers(),
  );

  void _onTextChange(String value) {
    if (debounceTimer != null) {
      debounceTimer.cancel();
    }
    debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (mounted) {
        final List<UserProfile> result =
            await Provider.of<SearchProvider>(context).searchMember(value);
        if (result != null && result.isNotEmpty) {
          queriedUsers.value = result;
        }
      }
    });
  }

  void _onUserSelected(UserProfile value) {
    _users.value.selection = placeUser(value, _users.value.selection);
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    _users.notifyListeners();
  }

  @override
  void dispose() {
    debounceTimer?.cancel();
    _users.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: <Widget>[Container()],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(.5),
        child: Container(
          height: .5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: <double>[
                  0.1,
                  0.9
                ],
                colors: <Color>[
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primary,
                ]),
          ),
        ),
      ),
      brightness: Brightness.light,
      elevation: 0,
      titleSpacing: 0.0,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    // Scaffold.of(context).openDrawer();
                    if (widget.appContext == 'collective') {
                      widget.openPerspectivesDrawer();
                    } else {
                      return;
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    color: Colors.transparent,
                    height: 48,
                    child: Row(
                      children: <Widget>[
                        Image.asset('assets/images/junto-mobile__logo.png',
                            height: 22.0, width: 22.0),
                        const SizedBox(width: 7.5),
                        Text(
                          widget.juntoAppBarTitle,
                          style: Theme.of(context).appBarTheme.textTheme.body1,
                        ),
                        const SizedBox(width: 2.5),
                        widget.appContext == 'collective'
                            ? Icon(
                                Icons.keyboard_arrow_down,
                                size: 17,
                                color: Theme.of(context).primaryColorLight,
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                );
              },
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return ListenableProvider<
                            ValueNotifier<SelectedUsers>>.value(
                          value: _users,
                          child: _SearchBottomSheet(
                            results: queriedUsers,
                            onProfileSelected: _onUserSelected,
                            onTextChange: _onTextChange,
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 42,
                    padding: const EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    color: Colors.transparent,
                    child: Icon(
                      Icons.search,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) => Container(
                        color: Colors.transparent,
                        child: Container(
                          height: MediaQuery.of(context).size.height * .9,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Notifications',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text('building this last...')
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 42,
                    color: Colors.transparent,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 10),
                    child: const Icon(
                      CustomIcons.moon,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _SearchBottomSheet extends StatefulWidget {
  const _SearchBottomSheet({
    Key key,
    @required this.onTextChange,
    @required this.onProfileSelected,
    @required this.results,
  }) : super(key: key);

  /// [ValueChanged] callback which exposes the text typed by the user
  final ValueChanged<String> onTextChange;

  /// [ValueChanged] callback which exposes the selected user profile
  final ValueChanged<UserProfile> onProfileSelected;

  /// [ValueNotifier] used to rebuild the results [ListView] with the data
  /// sent back from the server.
  final ValueNotifier<List<UserProfile>> results;

  @override
  __SearchBottomSheetState createState() => __SearchBottomSheetState();
}

class __SearchBottomSheetState extends State<_SearchBottomSheet> {
  PageController pageController = PageController(
    initialPage: 0,
  );

  int currentIndex;

  bool searchChannelsPage = true;
  bool searchMembersPage = false;
  bool searchSpheresPage = false;

  FocusNode textFieldFocusNode = FocusNode();

  List<UserProfile> profiles = <UserProfile>[
    UserProfile(
        firstName: 'Eric Yang',
        username: 'sunyata',
        profilePicture: 'assets/images/junto-mobile__eric.png'),
    UserProfile(
        firstName: 'Riley Wagner',
        username: 'wags',
        profilePicture: 'assets/images/junto-mobile__riley.png'),
    UserProfile(
        firstName: 'Dora Czovek',
        username: 'wingedmessenger',
        profilePicture: 'assets/images/junto-mobile__dora.png'),
    UserProfile(firstName: 'Urk', username: 'sunyata', profilePicture: ''),
  ];

  List<Sphere> spheres = <Sphere>[
    const Sphere(
      sphereTitle: 'Ecstatic Dance',
      sphereMembers: '12000',
      sphereImage: 'assets/images/junto-mobile__ecstatic.png',
      sphereHandle: 'ecstaticdance',
      sphereDescription:
          'Ecstatic dance is a space for movement, rhythm, non-judgment, and '
          'expression in its purest form. Come groove out with us!',
    ),
    const Sphere(
      sphereTitle: 'Flutter NYC',
      sphereMembers: '690',
      sphereImage: 'assets/images/junto-mobile__flutter.png',
      sphereHandle: 'flutternyc',
      sphereDescription:
          'Connect with other members in the Flutter NYC community and learn'
          ' about this amazing technology!',
    ),
    const Sphere(
      sphereTitle: 'Zen',
      sphereMembers: '77',
      sphereImage: 'assets/images/junto-mobile__stillmind.png',
      sphereHandle: 'zen',
      sphereDescription:
          '"To a mind that is still, the whole universe surrenders"',
    ),
  ];

  @override
  void initState() {
    super.initState();

    setState(() {
      currentIndex = 0;
    });
  }

  @override
  void dispose() {
    super.dispose();

    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //ignore:unused_local_variable
    final ValueNotifier<SelectedUsers> _selectedUsers =
        Provider.of<ValueNotifier<SelectedUsers>>(context);

    return Container(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * .9,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.search,
                    size: 20,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Transform.translate(
                      offset: Offset(0.0, 2),
                      child: TextField(
                        focusNode: textFieldFocusNode,
                        buildCounter: (
                          BuildContext context, {
                          int currentLength,
                          int maxLength,
                          bool isFocused,
                        }) =>
                            null,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0.0),
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        cursorColor: Theme.of(context).primaryColorDark,
                        cursorWidth: 1,
                        maxLines: null,
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        maxLength: 80,
                        textInputAction: TextInputAction.done,
                        onChanged: widget.onTextChange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    pageController.jumpToPage(0);
                  },
                  child: Text(
                    'Members',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: currentIndex == 0
                            ? Theme.of(context).primaryColorDark
                            : Theme.of(context).primaryColorLight),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    pageController.jumpToPage(1);
                  },
                  child: Text(
                    'Spheres',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: currentIndex == 1
                          ? Theme.of(context).primaryColorDark
                          : Theme.of(context).primaryColorLight,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                children: <Widget>[
                  // search members
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(children: <Widget>[
                          MemberPreview(profile: profiles[0]),
                          MemberPreview(profile: profiles[1]),
                          MemberPreview(profile: profiles[2]),
                          MemberPreview(profile: profiles[3]),
                        ]),
                      )
                    ],
                  ),
                  // search spheres
                  Column(
                    children: <Widget>[
                      Expanded(
                          child: ListView(
                        children: <Widget>[
                          // SpherePreviewSearch(group: spheres[0]),
                          // SpherePreviewSearch(group: spheres[1]),
                          // SpherePreviewSearch(group: spheres[2])
                        ],
                      ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
