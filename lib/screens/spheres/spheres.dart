import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/sphere_preview/sphere_preview.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview_select.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:provider/provider.dart';

/// This class renders the main screen for Spheres. It includes a widget to
/// create a screen as well as a ListView of all the sphere previews
class JuntoSpheres extends StatefulWidget {
  const JuntoSpheres({Key key, @required this.userProfile}) : super(key: key);

  final UserProfile userProfile;

  @override
  State<StatefulWidget> createState() => JuntoSpheresState();
}

class JuntoSpheresState extends State<JuntoSpheres> with ListDistinct {
  UserService _userProvider;
  final AsyncMemoizer<UserGroupsResponse> _memoizer =
      AsyncMemoizer<UserGroupsResponse>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserService>(context);
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
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        children: <Widget>[
          // Create sphere
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   CupertinoPageRoute<dynamic>(
              //     builder: (BuildContext context) => CreateSphere(),
              //   ),
              // );              
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) => Container(
                  color: const Color(0xff737373),
                  child: _CreateSphereBottomSheet(),
                ),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: JuntoPalette.juntoFade, width: .5),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                  vertical: 20,),
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

  TextEditingController _nameController;
  TextEditingController _handleController;
  TextEditingController _descriptionController;

  TextEditingController _principleTitle;
  TextEditingController _principleBody;
  TextEditingController _principleTitleTwo;
  TextEditingController _principleBodyTwo;
  TextEditingController _principleTitleThree;
  TextEditingController _principleBodyThree;
  TextEditingController _principleTitleFour;
  TextEditingController _principleBodyFour;
  TextEditingController _principleTitleFive;
  TextEditingController _principleBodyFive;
  TextEditingController _principleTitleSix;
  TextEditingController _principleBodySix;
  TextEditingController _principleTitleSeven;
  TextEditingController _principleBodySeven;

  List<Map> principles = [
    {"title": "", "body": ""}
  ];

  List<UserProfile> profiles = <UserProfile>[
    UserProfile(
      firstName: 'Eric Yang',
      username: 'sunyata',
      profilePicture: 'assets/images/junto-mobile__eric.png'
    ),
    UserProfile(
      firstName: 'Riley Wagner',
      username: 'wags',
      profilePicture: 'assets/images/junto-mobile__riley.png'
    ),
    UserProfile(
      firstName: 'Dora Czovek',
      username: 'wingedmessenger',
      profilePicture: 'assets/images/junto-mobile__dora.png'
    )        
  ];

  @override
  void initState() {
    _nameController = TextEditingController();
    _handleController = TextEditingController();
    _descriptionController = TextEditingController();
    _principleTitle = TextEditingController();
    _principleBody = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _handleController.dispose();
    _descriptionController.dispose();
    _principleTitle.dispose();
    _principleBody.dispose();
    super.dispose();
  }

  void _createSphere() async {
    final UserProfile _profile =
        await Provider.of<UserService>(context).readLocalUser();
    final sphereName = _nameController.value.text;
    final sphereHandle = _handleController.value.text;
    final sphereDescription = _descriptionController.value.text;
    final CentralizedSphere sphere = CentralizedSphere(
      name: sphereName,
      description: sphereDescription,
      facilitators: <String>[
        _profile.address,
      ],
      photo: '',
      members: [],
      principles: "",
      sphereHandle: sphereHandle,
      privacy: 'Public',
    );

    try {
      await Provider.of<GroupRepo>(context).createSphere(sphere);
    } catch (error) {
      print(error);
    }
  }

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
              _currentPage == 4
                  ? GestureDetector(
                      onTap: () {
                        _createSphere();
                      },
                      child: Text('create'),
                    )
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
                _createSpherePrinciples(),
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
    return ListView(
      children: <Widget>[
        const SizedBox(height: 25),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Color(0xfff2f2f2),
          ),
          alignment: Alignment.center,
          child: Text('add a cover photo'),
        ),
        const SizedBox(height: 15),
        Container(
          width: MediaQuery.of(context).size.width,
          child: TextField(
            controller: _nameController,
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
                hintText: 'Name your sphere*',
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
            controller: _handleController,
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
                hintText: 'Give your sphere a unique username*',
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
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: TextField(
            controller: _descriptionController,
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
            textInputAction: TextInputAction.newline,
          ),
        ),
      ],
    );
  }

  _spherePrinciple(
    index,
  ) {
    var title;
    var body;
    if (index == 1) {
      title = _principleTitle;
      body = _principleBody;
    } else if (index == 2) {
      title = _principleTitleTwo;
      body = _principleTitleTwo;
    } else if (index == 3) {
      title = _principleTitleThree;
      body = _principleTitleThree;
    } else if (index == 4) {
      title = _principleTitleFour;
      body = _principleTitleFour;
    } else if (index == 5) {
      title = _principleTitleFive;
      body = _principleTitleFive;
    } else if (index == 6) {
      title = _principleTitleSix;
      body = _principleTitleSix;
    } else if (index == 7) {
      title = _principleTitleSeven;
      body = _principleTitleSeven;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            index.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: const Color(0xff999999),
            ),
          ),
          const SizedBox(width: 15),
          Container(
            height: 17,
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: Color(0xffeeeeee), width: 2),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: title,
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
                        hintText: 'Principle title',
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
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: body,
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
                        hintText: 'Describe this principle',
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
              ],
            ),
          )
        ],
      ),
    );
  }

  _createSpherePrinciples() {
    return ListView(
      children: [
        const SizedBox(height: 15),
        for (var i = 0; i < principles.length; i++) _spherePrinciple(i + 1),
        GestureDetector(
          onTap: () {
            if (principles.length < 7) {
              if (principles.length == 2) {
                setState(() {
                  _principleTitleTwo = TextEditingController();
                  _principleTitleTwo = TextEditingController();
                });
              } else if (principles.length == 3) {
                setState(() {
                  _principleTitleThree = TextEditingController();
                  _principleTitleThree = TextEditingController();
                });
              } else if (principles.length == 4) {
                setState(() {
                  _principleTitleFour = TextEditingController();
                  _principleTitleFour = TextEditingController();
                });
              } else if (principles.length == 5) {
                setState(() {
                  _principleTitleFive = TextEditingController();
                  _principleTitleFive = TextEditingController();
                });
              } else if (principles.length == 6) {
                setState(() {
                  _principleTitleSix = TextEditingController();
                  _principleTitleSix = TextEditingController();
                });
              } else if (principles.length == 7) {
                setState(() {
                  _principleTitleSeven = TextEditingController();
                  _principleTitleSeven = TextEditingController();
                });
              }

              setState(() {
                principles.add({"title": "", "body": ""});
                print(principles.length);
              });
            }
          },
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'New Principle',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xff999999),
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.add,
                    size: 17,
                    color: const Color(0xff999999),
                  )
                ],
              )),
        ),
        GestureDetector(
            onTap: () {
              print(principles);
            },
            child: const Text('test'))
      ],
    );
  }

  Widget _createSphereMembers() {
    return Column(
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
                color: const Color(0xff999999),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0.0, 2.5),
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
        const SizedBox(height: 10),
        Expanded(
          child: PageView(
            controller: _searchMembersController,
            onPageChanged: (int index) {
              setState(() {
                _searchMembersIndex = index;
              });
            },
            children: <Widget>[
              ListView(
                children: <Widget>[
                  MemberPreviewSelect(profile: profiles[0]),
                  MemberPreviewSelect(profile: profiles[1]),
                  MemberPreviewSelect(profile: profiles[2]),

   
                ],
              ),
              ListView(
                children: <Widget>[
                  // _memberPreview(),
                ],
              ),
              ListView(
                children: <Widget>[
                  // _memberPreview(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _createSphereFacilitators() {
    return Column(
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
                color: const Color(0xff999999),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0.0, 2.5),
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
        const SizedBox(height: 10),
        Expanded(
          child: PageView(
            controller: _searchFacilitatorsController,
            onPageChanged: (int index) {
              setState(() {
                _searchFacilitatorsIndex = index;
              });
            },
            children: const <Widget>[
              Text('render list of connections'),
              Text('render list of subscriptions'),
              Text('render list of all members (pagination tbd)')
            ],
          ),
        ),
      ],
    );
  }

  Widget _createSpherePrivacy() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
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
                    children: const <Widget>[
                      Text(
                        'Public',
                        style: TextStyle(
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
                    children: const <Widget>[
                      Text(
                        'Shared',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text('Only members can read expressions '
                          'and share to it. Facilitators can invite members or accept their request to join.')
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
                    children: const <Widget>[
                      Text(
                        'Private',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                          'Members must be invited into this sphere. This sphere is only searchable by members.')
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
