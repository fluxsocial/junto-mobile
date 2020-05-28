import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/create_perspective.dart'
    show SelectedUsers;
import 'package:provider/provider.dart';

// Junto app bar used throughout the main screens. Rendered in JuntoTemplate.
class CollectiveAppBar extends SliverPersistentHeaderDelegate {
  CollectiveAppBar({
    @required this.expandedHeight,
    this.newAppBarTitle,
    this.openPerspectivesDrawer,
  });

  final double expandedHeight;
  final String newAppBarTitle;
  final Function openPerspectivesDrawer;

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

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
            onTap: openPerspectivesDrawer,
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
                    newAppBarTitle,
                    style: Theme.of(context).appBarTheme.textTheme.bodyText1,
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
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class JuntoAppbarSearch extends StatefulWidget {
  const JuntoAppbarSearch({
    Key key,
    this.onTextChange,
    this.onProfileSelected,
    this.results,
  }) : super(key: key);

  /// [ValueChanged] callback which exposes the text typed by the user
  final ValueChanged<String> onTextChange;

  /// [ValueChanged] callback which exposes the selected user profile
  final ValueChanged<UserProfile> onProfileSelected;

  /// [ValueNotifier] used to rebuild the results [ListView] with the data
  /// sent back from the server.
  final ValueNotifier<List<UserProfile>> results;

  @override
  _JuntoAppbarSearchState createState() => _JuntoAppbarSearchState();
}

class _JuntoAppbarSearchState extends State<JuntoAppbarSearch> {
  PageController pageController = PageController(
    initialPage: 0,
  );

  int currentIndex;

  bool searchChannelsPage = true;
  bool searchMembersPage = false;
  bool searchSpheresPage = false;

  // ignore: unused_field
  ValueNotifier<SelectedUsers> _selectedUsers;

  FocusNode textFieldFocusNode;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  @override
  void didChangeDependencies() {
    textFieldFocusNode = FocusNode();
    super.didChangeDependencies();
    _selectedUsers = Provider.of<ValueNotifier<SelectedUsers>>(context);
  }

  @override
  void dispose() {
    super.dispose();
    textFieldFocusNode.dispose();
    pageController.dispose();
  }

  //TODO(Nash): Refactor to display connections when this feature is implemented
  Widget _buildChannelsSearch() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: const <Widget>[],
          ),
        )
      ],
    );
  }

  //TODO(Nash): Refactor to display connections when this feature is implemented
  Widget _buildMemeberSearch() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: const <Widget>[],
          ),
        )
      ],
    );
  }

  // TODO(Nash): Refactor to display a list of user spheres.
  Widget _buildSphereSearch() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: const <Widget>[],
          ),
        )
      ],
    );
  }

  void _handlePageChange(int value) {
    setState(() {
      currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(width: 7.5),
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
                          contentPadding: const EdgeInsets.all(0),
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
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Text(
                      'Channels',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: currentIndex == 0
                              ? Theme.of(context).primaryColorDark
                              : Theme.of(context).primaryColorLight),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    pageController.jumpToPage(1);
                  },
                  child: Text(
                    'Members',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: currentIndex == 1
                            ? Theme.of(context).primaryColorDark
                            : Theme.of(context).primaryColorLight),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    pageController.jumpToPage(2);
                  },
                  child: Text(
                    'Spheres',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: currentIndex == 2
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
                onPageChanged: _handlePageChange,
                children: <Widget>[
                  _buildChannelsSearch(),
                  _buildSphereSearch(),
                  _buildMemeberSearch(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
