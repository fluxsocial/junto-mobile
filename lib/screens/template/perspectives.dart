import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview_select.dart';
import 'package:junto_beta_mobile/models/models.dart';

class JuntoPerspectives extends StatefulWidget {
  const JuntoPerspectives({
    Key key,
    @required this.changePerspective,
  }) : super(key: key);

  final Function changePerspective;

  @override
  State<StatefulWidget> createState() => JuntoPerspectivesState();
}

class JuntoPerspectivesState extends State<JuntoPerspectives> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * .9,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: <double>[0.2, 0.9],
            colors: <Color>[
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.primary
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/junto-mobile__logo--white.png',
                        height: 22.0, width: 22.0),
                    const SizedBox(width: 15),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xff4263A3),
                      width: .75,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'PERSPECTIVES',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) => Container(
                            color: Colors.transparent,
                            child: _CreatePerspectiveBottomSheet(),
                          ),
                        );
                      },
                      child: Container(
                        height: 38,
                        width: 38,
                        color: Colors.transparent,
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.add, color: Colors.white, size: 17),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    _buildPerspective('JUNTO', 'all'),
                    _buildPerspective('Connections', '99'),
                    _buildPerspective('Subscriptions', '220'),
                    _buildPerspective('Degrees of separation', 'all'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerspective(String name, String members) {
    return GestureDetector(
      onTap: () {
        widget.changePerspective(name);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              letterSpacing: 1.2,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            members + ' members',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                letterSpacing: 1.2,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                _openPerspectiveBottomSheet(name);
              },
              child: const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  _perspectiveText(perspective) {
    if (perspective == 'JUNTO') {
      return 'The Junto perspective contains all public expressions from '
          'every member of Junto.';
    } else if (perspective == 'Connections') {
      return 'The Connections perspective contains all public expressions from '
          'your 1st degree connections.';
    } else if (perspective == 'Subscriptions') {
      return "The Subscriptions perspective contains all public expressions from "
          "members you're subscribed to.";
    } else if (perspective == 'Degrees of separation') {
      return 'The Degrees of separation perspective allows you to discover expression from one to six degrees of separtion away from you!';
    }
  }

  void _openPerspectiveBottomSheet(perspective) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) => Container(
        color: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height * .3,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Text('cancel'),
                  Text(perspective, style: Theme.of(context).textTheme.title),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                child: Text(_perspectiveText(perspective),
                    style: Theme.of(context).textTheme.caption),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CreatePerspectiveBottomSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreatePerspectiveBottomSheetState();
  }
}

class _CreatePerspectiveBottomSheetState
    extends State<_CreatePerspectiveBottomSheet> {
  final PageController _searchMembersController =
      PageController(initialPage: 0);

  // add members
  int _searchMembersIndex = 0;

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
    UserProfile(
        firstName: 'Josh Parkin',
        username: 'jdeepee',
        profilePicture: 'assets/images/junto-mobile__josh.png'),
    UserProfile(
        firstName: 'Nash Ramdial',
        username: 'nash',
        profilePicture: 'assets/images/junto-mobile__nash.png')
  ];

  @override
  void dispose() {
    super.dispose();

    _searchMembersController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('New Perspective', style: Theme.of(context).textTheme.title),
              Text(
                'create',
                style: Theme.of(context).textTheme.caption,
              )
            ],
          ),
          const SizedBox(height: 20),
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
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                border: InputBorder.none,
                hintText: 'Name perspective',
                hintStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColorLight),
              ),
              cursorColor: Theme.of(context).primaryColorDark,
              cursorWidth: 2,
              maxLines: 1,
              style: Theme.of(context).textTheme.caption,
              maxLength: 80,
              textInputAction: TextInputAction.done,
            ),
          ),
          SizedBox(height: 10),
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
              children: <Widget>[
                Icon(
                  Icons.search,
                  size: 20,
                  color: Theme.of(context).primaryColorLight,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Transform.translate(
                    offset: const Offset(0.0, 4),
                    child: TextField(
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
                          hintText: 'add members',
                          hintStyle: const TextStyle(
                            fontSize: 15,
                            color: Color(0xff999999),
                          )),
                      cursorColor: Theme.of(context).primaryColorDark,
                      cursorWidth: 2,
                      maxLines: null,
                      style: Theme.of(context).textTheme.caption,
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
                  'Connections',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _searchMembersIndex == 0
                        ? Theme.of(context).primaryColorDark
                        : Theme.of(context).primaryColorLight,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  _searchMembersController.jumpToPage(1);
                  _searchMembersIndex = 1;
                },
                child: Text(
                  'Subscriptions',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _searchMembersIndex == 1
                        ? Theme.of(context).primaryColorDark
                        : Theme.of(context).primaryColorLight,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  _searchMembersController.jumpToPage(2);
                  _searchMembersIndex = 2;
                },
                child: Text(
                  'All',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _searchMembersIndex == 2
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
                    MemberPreviewSelect(profile: profiles[3]),
                    MemberPreviewSelect(profile: profiles[4]),
                  ],
                ),
                ListView(
                  children: const <Widget>[
                    // _memberPreview(),
                  ],
                ),
                ListView(
                  children: const <Widget>[
                    // _memberPreview(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
