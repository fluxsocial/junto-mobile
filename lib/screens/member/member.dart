import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/member/member_appbar.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:carousel_slider/carousel_slider.dart';

//FIXME: Build method and bottom sheet should be broken up
class JuntoMember extends StatefulWidget {
  const JuntoMember({
    Key key,
    @required this.profile,
  }) : super(key: key);

  static Route<dynamic> route(UserProfile profile) {
    return CupertinoPageRoute<dynamic>(
      builder: (BuildContext context) {
        return JuntoMember(
          profile: profile,
        );
      },
    );
  }

  final UserProfile profile;

  @override
  _JuntoMemberState createState() => _JuntoMemberState();
}

class _JuntoMemberState extends State<JuntoMember> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> _tabs = <String>['About', 'Expressions'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: MemberAppbar(widget.profile.username),
      ),
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: _tabs.length,
        child: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                brightness: Brightness.light,
                automaticallyImplyLeading: false,
                primary: false,
                actions: const <Widget>[SizedBox(height: 0, width: 0)],
                backgroundColor: Colors.white,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * .24,
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        alignment: Alignment.bottomLeft,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: <double>[0.1, 0.9],
                            colors: <Color>[
                              JuntoPalette.juntoSecondary,
                              JuntoPalette.juntoPrimary,
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const SizedBox(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                const Flexible(
                                  child: Text(
                                    // name,
                                    'Eric Yang',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          Container(
                                        color: Colors.transparent,
                                        child: MemberRelationshipsModal(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 7.5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 1.5),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        const SizedBox(width: 14),
                                        Image.asset(
                                            'assets/images/junto-mobile__infinity.png',
                                            color: Colors.white,
                                            height: 14),
                                        const SizedBox(width: 2),
                                        Icon(Icons.keyboard_arrow_down,
                                            size: 12, color: Colors.white)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                expandedHeight: MediaQuery.of(context).size.height * .24,
                forceElevated: false,
              ),
              SliverPersistentHeader(
                delegate: JuntoAppBarDelegate(
                  TabBar(
                    labelPadding: const EdgeInsets.all(0),
                    isScrollable: true,
                    labelColor: const Color(0xff333333),
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff555555),
                    ),
                    indicatorWeight: 0.0001,
                    tabs: <Widget>[
                      for (String name in _tabs)
                        Container(
                          margin: const EdgeInsets.only(right: 24),
                          color: Colors.white,
                          child: Tab(
                            text: name,
                          ),
                        ),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              ListView(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 10),
                children: <Widget>[
                  CarouselSlider(
                    viewportFraction: 1.0,
                    height: MediaQuery.of(context).size.width - 20,
                    enableInfiniteScroll: false,
                    items: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(right: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                            'assets/images/junto-mobile__eric.png',
                            fit: BoxFit.cover),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(right: 10),
                        child: Image.asset(
                            'assets/images/junto-mobile__eric--qigong.png',
                            fit: BoxFit.cover),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Color(0xffeeeeee), width: 1.5),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                'assets/images/junto-mobile__location.png',
                                height: 15,
                                color: const Color(0xff777777),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                'Spirit',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color(0xff777777),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                'assets/images/junto-mobile__link.png',
                                height: 15,
                                color: const Color(0xff777777),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'junto.foundation',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: JuntoPalette.juntoPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    child: const Text(
                      'Founder/Executive Director @junto; Mr. Snack @lunchbox; Student of QiGong',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff333333),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              ListView(
                children: <Widget>[],
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom [SliverPersistentHeaderDelegate] used on Den.
class JuntoAppBarDelegate extends SliverPersistentHeaderDelegate {
  JuntoAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height + .5;

  @override
  double get maxExtent => _tabBar.preferredSize.height + .5;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xffeeeeee), width: .5),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(JuntoAppBarDelegate oldDelegate) {
    return false;
  }
}

class MemberRelationshipsModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .4,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 5,
                    width: MediaQuery.of(context).size.width * .1,
                    decoration: BoxDecoration(
                        color: const Color(0xffeeeeee),
                        borderRadius: BorderRadius.circular(100)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: Row(
                  children: <Widget>[
                    Icon(
                      Icons.visibility,
                      size: 17,
                      color: const Color(0xff555555),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      'Subscribe',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                  ],
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: Row(
                  children: <Widget>[
                    Icon(
                      CustomIcons.circle,
                      size: 17,
                      color: const Color(0xff555555),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      'Connect',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                  ],
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                onTap: () {},
                title: Row(
                  children: <Widget>[
                    Icon(
                      CustomIcons.packs,
                      size: 17,
                      color: const Color(0xff555555),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      'Join Pack',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
