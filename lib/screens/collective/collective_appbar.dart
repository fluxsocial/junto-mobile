
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives'
    '/create_perspective/create_perspective.dart' show SelectedUsers;
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:provider/provider.dart';

// Junto app bar used throughout the main screens. Rendered in JuntoTemplate.
class CollectiveAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final String newappbartitle;
  final Function openPerspectivesDrawer;

  const CollectiveAppBar(
      {@required this.expandedHeight,
      this.newappbartitle,
      this.openPerspectivesDrawer});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      height: 85,
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: .75,
            ),
          ),
          color: Theme.of(context).backgroundColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              openPerspectivesDrawer();
            },
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.only(left: 10),
              color: Colors.transparent,
              height: 36,
              child: Row(
                children: <Widget>[
                  Image.asset('assets/images/junto-mobile__logo.png',
                      height: 22.0, width: 22.0),
                  const SizedBox(width: 7.5),
                  Text(
                    newappbartitle,
                    style: Theme.of(context).appBarTheme.textTheme.body1,
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 42,
                  padding: const EdgeInsets.only(right: 10),
                  alignment: Alignment.bottomRight,
                  color: Colors.transparent,
                  child: Icon(Icons.search,
                      size: 22, color: Theme.of(context).primaryColor),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 42,
                  color: Colors.transparent,
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(CustomIcons.moon,
                      size: 22, color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
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
        name: 'Eric Yang',
        username: 'sunyata',
        profilePicture: 'assets/images/junto-mobile__eric.png'),
    UserProfile(
        name: 'Riley Wagner',
        username: 'wags',
        profilePicture: 'assets/images/junto-mobile__riley.png'),
    UserProfile(
        name: 'Dora Czovek',
        username: 'wingedmessenger',
        profilePicture: 'assets/images/junto-mobile__dora.png'),
    UserProfile(name: 'Urk', username: 'sunyata', profilePicture: ''),
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
    // ignore:unused_local_variable
    final ValueNotifier<SelectedUsers> _selectedUsers =
        Provider.of<ValueNotifier<SelectedUsers>>(context);

    return Container(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * .9,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(bottom: 5),
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
                      offset: const Offset(0.0, 2),
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
                        children: const <Widget>[
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
