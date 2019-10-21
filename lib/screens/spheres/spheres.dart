import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/providers/provider.dart';
import 'package:junto_beta_mobile/screens/spheres/create_sphere/create_sphere.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_preview.dart';
import 'package:junto_beta_mobile/styles.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart' show AsyncMemoizer;

/// This class renders the main screen for Spheres. It includes a widget to
/// create a screen as well as a ListView of all the sphere previews
class JuntoSpheres extends StatefulWidget {
  const JuntoSpheres({Key key, @required this.userProfile}) : super(key: key);

  final UserProfile userProfile;

  @override
  State<StatefulWidget> createState() => JuntoSpheresState();
}

class JuntoSpheresState extends State<JuntoSpheres> with ListDistinct {
  UserProvider _userProvider;
  final AsyncMemoizer<UserGroupsResponse> _memoizer =
      AsyncMemoizer<UserGroupsResponse>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserProvider>(context);
  }

  Widget buildError() {
    return Container(
      height: 400,
      alignment: Alignment.center,
      child: Text(
        'Oops, something is wrong!',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }

  Future<UserGroupsResponse> getUserGroups() async {
    return _memoizer.runOnce(
      () => _userProvider.getUserGroups(widget.userProfile.address),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          // Create sphere
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) => Container(
                  color: const Color(0xff737373),
                  child: _CreateSphereBottomSheet(),
                ),
              );

              // Navigator.push(
              //   context,
              //   CupertinoPageRoute<dynamic>(
              //     builder: (BuildContext context) => CreateSphere(),
              //   ),
              // );
            },
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: JuntoPalette.juntoFade, width: .5),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                  vertical: 20, horizontal: JuntoStyles.horizontalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Text('Create a sphere', style: JuntoStyles.title),
                  Text(
                    '+',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<UserGroupsResponse>(
            future: getUserGroups(),
            builder: (BuildContext context,
                AsyncSnapshot<UserGroupsResponse> snapshot) {
              if (snapshot.hasError) {
                return buildError();
              }
              if (snapshot.hasData && !snapshot.hasError) {
                final List<Group> ownedGroups = snapshot.data.owned;
                final List<Group> associatedGroups = snapshot.data.associated;
                final List<Group> userGroups =
                    distinct<Group>(ownedGroups, associatedGroups)
                        .where((Group group) => group.groupType == 'Sphere')
                        .toList();
                return ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: <Widget>[
                    for (Group group in userGroups)
                      SpherePreview(
                        group: group,
                      ),
                  ],
                );
              }

              return Container(
                height: 100.0,
                width: 100.0,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CreateSphereBottomSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateSphereBottomSheetState();
  }
}

class _CreateSphereBottomSheetState extends State<_CreateSphereBottomSheet> {
  int _currentPage = 0;
  final PageController _createSphereController = PageController(initialPage: 0);
  final PageController _searchMembersController =
      PageController(initialPage: 0);
  final PageController _searchFacilitatorsController =
      PageController(initialPage: 0);

  // add members
  int _searchMembersIndex = 0;

  // add facilitators
  int _searchFacilitatorsIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .9,
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
          const SizedBox(height: 10),
          // bottom sheet app bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _currentPage == 0
                  ? Text(
                      'New Sphere',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff333333),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        _createSphereController.previousPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn);
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: 50,
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: Color(0xff555555),
                        ),
                      ),
                    ),
              _currentPage == 3
                  ? GestureDetector(child: Text('create'))
                  : GestureDetector(
                      onTap: () {
                        _createSphereController.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn);
                        _searchMembersIndex = 0;
                        _searchFacilitatorsIndex = 0;
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        width: 50,
                        child: Text(
                          'next',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
            ],
          ),
          Expanded(
            child: PageView(
              controller: _createSphereController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (int index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: <Widget>[
                _createSphereDetails(),
                _createSphereMembers(),
                _createSphereFacilitators(),
                _createSpherePrivacy()
              ],
            ),
          )
        ],
      ),
    );
  }

  _createSphereDetails() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 25),
        Container(
          width: MediaQuery.of(context).size.width,
          child: TextField(
            buildCounter: (
              BuildContext context, {
              int currentLength,
              int maxLength,
              bool isFocused,
            }) =>
                null,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(0),
                border: InputBorder.none,
                hintText: 'Name your sphere',
                hintStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff999999),
                )),
            cursorColor: const Color(0xff333333),
            cursorWidth: 2,
            maxLines: 1,
            style: const TextStyle(
                color: Color(0xff333333),
                fontSize: 15,
                fontWeight: FontWeight.w700),
            maxLength: 80,
            textInputAction: TextInputAction.done,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          width: MediaQuery.of(context).size.width,
          child: TextField(
            buildCounter: (
              BuildContext context, {
              int currentLength,
              int maxLength,
              bool isFocused,
            }) =>
                null,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(0),
                border: InputBorder.none,
                hintText: 'Write your sphere bio / purpose',
                hintStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff999999),
                )),
            cursorColor: const Color(0xff333333),
            cursorWidth: 2,
            maxLines: null,
            style: const TextStyle(
                color: Color(0xff333333),
                fontSize: 15,
                fontWeight: FontWeight.w500),
            maxLength: 240,
            textInputAction: TextInputAction.done,
          ),
        ),
      ],
    );
  }

  _createSphereMembers() {
    return Column(
      children: <Widget>[
        // const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffeeeeee),
                    width: .75,
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.search,
                    size: 20,
                    color: Color(0xff999999),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Transform.translate(
                      offset: Offset(0.0, 2.5),
                      child: TextField(
                        buildCounter: (
                          BuildContext context, {
                          int currentLength,
                          int maxLength,
                          bool isFocused,
                        }) =>
                            null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'add members to your sphere',
                          hintStyle: TextStyle(
                              color: Color(0xff999999),
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        cursorColor: const Color(0xff333333),
                        cursorWidth: 2,
                        maxLines: null,
                        style: const TextStyle(
                            color: Color(0xff333333),
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        maxLength: 80,
                        textInputAction: TextInputAction.done,
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
                    _searchMembersController.jumpToPage(0);
                    _searchMembersIndex = 0;
                  },
                  child: Text(
                    'CONNECTIONS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _searchMembersIndex == 0
                          ? const Color(0xff333333)
                          : const Color(0xff999999),
                    ),
                  ),
                ),
                const SizedBox(width: 25),
                GestureDetector(
                  onTap: () {
                    _searchMembersController.jumpToPage(1);
                    _searchMembersIndex = 1;
                  },
                  child: Text(
                    'SUBSCRIPTIONS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _searchMembersIndex == 1
                          ? const Color(0xff333333)
                          : const Color(0xff999999),
                    ),
                  ),
                ),
                const SizedBox(width: 25),
                GestureDetector(
                  onTap: () {
                    _searchMembersController.jumpToPage(2);
                    _searchMembersIndex = 2;
                  },
                  child: Text(
                    'ALL',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _searchMembersIndex == 2
                          ? const Color(0xff333333)
                          : const Color(0xff999999),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height * .7,
              child: PageView(
                controller: _searchMembersController,
                onPageChanged: (int index) {
                  setState(() {
                    _searchMembersIndex = index;
                  });
                },
                children: <Widget>[
                  Text('render list of connections'),
                  Text('render list of subscriptions'),
                  Text('render list of all members (pagination tbd)')
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _createSphereFacilitators() {
    return Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffeeeeee),
                    width: .75,
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.search,
                    size: 20,
                    color: Color(0xff999999),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Transform.translate(
                      offset: Offset(0.0, 2.5),
                      child: TextField(
                        buildCounter: (
                          BuildContext context, {
                          int currentLength,
                          int maxLength,
                          bool isFocused,
                        }) =>
                            null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'add facilitators to your sphere',
                          hintStyle: TextStyle(
                              color: Color(0xff999999),
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        cursorColor: const Color(0xff333333),
                        cursorWidth: 2,
                        maxLines: null,
                        style: const TextStyle(
                            color: Color(0xff333333),
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        maxLength: 80,
                        textInputAction: TextInputAction.done,
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
                    _searchFacilitatorsController.jumpToPage(0);
                    _searchFacilitatorsIndex = 0;
                  },
                  child: Text(
                    'CONNECTIONS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _searchFacilitatorsIndex == 0
                          ? const Color(0xff333333)
                          : const Color(0xff999999),
                    ),
                  ),
                ),
                const SizedBox(width: 25),
                GestureDetector(
                  onTap: () {
                    _searchFacilitatorsController.jumpToPage(1);
                    _searchFacilitatorsIndex = 1;
                  },
                  child: Text(
                    'SUBSCRIPTIONS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _searchFacilitatorsIndex == 1
                          ? const Color(0xff333333)
                          : const Color(0xff999999),
                    ),
                  ),
                ),
                const SizedBox(width: 25),
                GestureDetector(
                  onTap: () {
                    _searchFacilitatorsController.jumpToPage(2);
                    _searchFacilitatorsIndex = 2;
                  },
                  child: Text(
                    'ALL',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _searchFacilitatorsIndex == 2
                          ? const Color(0xff333333)
                          : const Color(0xff999999),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height * .7,
              child: PageView(
                controller: _searchFacilitatorsController,
                onPageChanged: (int index) {
                  setState(() {
                    _searchFacilitatorsIndex = index;
                  });
                },
                children: <Widget>[
                  Text('render list of connections'),
                  Text('render list of subscriptions'),
                  Text('render list of all members (pagination tbd)')
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _createSpherePrivacy() {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * .75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Public',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text('Anyone can join this sphere, read its, '
                          'expressions and share to it')
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: kThemeChangeDuration,
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.white, Colors.white],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight),
                    // color: widget.isSelected ? JuntoPalette.juntoPrimary : null,
                    border: Border.all(
                      color: const Color(0xffeeeeee),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * .75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Shared',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text('Anyone can join this sphere, read its, '
                          'expressions and share to it')
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: kThemeChangeDuration,
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.white, Colors.white],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight),
                    // color: widget.isSelected ? JuntoPalette.juntoPrimary : null,
                    border: Border.all(
                      color: const Color(0xffeeeeee),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * .75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Private',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text('Anyone can join this sphere, read its, '
                          'expressions and share to it')
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: kThemeChangeDuration,
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.white, Colors.white],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight),
                    // color: widget.isSelected ? JuntoPalette.juntoPrimary : null,
                    border: Border.all(
                      color: const Color(0xffeeeeee),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                )
              ],
            ),
          ),
        )                
      ],
    );
  }
}
