import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_open/sphere_open_appbar.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_open/sphere_open_facilitators.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_open/sphere_open_members.dart';
import 'package:junto_beta_mobile/widgets/create_fab.dart';
import 'package:junto_beta_mobile/widgets/expression_preview/expression_preview.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';

class SphereOpen extends StatefulWidget {
  const SphereOpen({
    Key key,
    this.group,
  }) : super(key: key);

  final Group group;

  @override
  State<StatefulWidget> createState() {
    return SphereOpenState();
  }
}

class SphereOpenState extends State<SphereOpen> with HideFab {
  ScrollController _hideFABController;
  ValueNotifier<bool> _isVisible;
  List<Users> _members;

  List<CentralizedExpressionResponse> expressions;

  @override
  void initState() {
    super.initState();
    _hideFABController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hideFABController.addListener(_onScrollingHasChanged);
      _hideFABController.position.isScrollingNotifier.addListener(
        _onScrollingHasChanged,
      );
    });
    _isVisible = ValueNotifier<bool>(true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    expressions = Provider.of<ExpressionRepo>(context).collectiveExpressions;
    _getMembers();
  }

  void _onScrollingHasChanged() {
    super.hideFabOnScroll(_hideFABController, _isVisible);
  }

  @override
  void dispose() {
    _hideFABController.removeListener(_onScrollingHasChanged);
    _hideFABController.dispose();
    super.dispose();
  }

  Future<void> _getMembers() async {
    final List<Users> results =
        await Provider.of<GroupRepo>(context).getGroupMembers(
      widget.group.address,
    );
    setState(() => _members = results);
  }

  final List<String> _tabs = <String>['About', 'Discussion', 'Events'];

  List<Principle> principles = <Principle>[
    const Principle(
      title: 'Be a nice person because nice people get chocolate',
      body: 'Engage with empathy and respect for one another. We are more than '
          'viewpoints that may oppose each other at times. We are human beings '
          ':)',
    ),
    const Principle(
      title: 'All walks of life',
      body: 'This is a communal space where people from all walks of life are'
          ' welcome',
    ),
  ];

  bool _principlesFullView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: SphereOpenAppbar(
          widget.group.groupData.sphereHandle,
          widget.group.groupData.photo,
        ),
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _isVisible,
        builder: (BuildContext context, bool visible, Widget child) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: visible ? 1.0 : 0.0,
            child: child,
          );
        },
        child: CreateFAB(expressionLayer: widget.group.groupData.name),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: _tabs.length,
          child: NestedScrollView(
            controller: _hideFABController,
            physics: const ClampingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
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
                      children: <Widget>[
                        Container(
                          constraints: const BoxConstraints.expand(height: 200),
                          child: Image.asset(
                            'assets/images/junto-mobile__stillmind.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: JuntoStyles.horizontalPadding,
                            vertical: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          widget.group.groupData.name,
                                          style: const TextStyle(
                                            color: JuntoPalette.juntoGrey,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 15),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: <Color>[
                                      JuntoPalette.juntoSecondary,
                                      JuntoPalette.juntoPrimary
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Join Sphere',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  expandedHeight: MediaQuery.of(context).size.height * .2 + 158,
                  forceElevated: false,
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      labelPadding: const EdgeInsets.all(0),
                      isScrollable: true,
                      labelColor: const Color(0xff333333),
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff333333),
                      ),
                      indicatorWeight: 0.0001,
                      tabs: _tabs
                          .map((String name) => Container(
                              margin: const EdgeInsets.only(right: 24),
                              color: Colors.white,
                              child: Tab(
                                text: name,
                              )))
                          .toList(),
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
                // These are the contents of the tab views, below the tabs.
                children: <Widget>[
                  _buildAboutView(),
                  _buildExpressionView(),
                  _buildEventsView()
                ]),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutView() {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: JuntoStyles.horizontalPadding,
            vertical: 15,
          ),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: JuntoPalette.juntoFade,
                width: .75,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute<dynamic>(
                      builder: (BuildContext context) =>
                          SphereOpenMembers(users: _members),
                    ),
                  );
                },
                child: const MemberRow(),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute<dynamic>(
                builder: (BuildContext context) =>
                    const SphereOpenFacilitators(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: JuntoPalette.juntoFade,
                  width: .75,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text('Facilitators', style: JuntoStyles.header),
                          SizedBox(height: 10),
                          Text('Eric Yang and 7 others'),
                        ]),
                    ClipOval(
                      child: Image.asset(
                        'assets/images/junto-mobile__eric.png',
                        height: 45.0,
                        width: 45.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        if (principles.isNotEmpty)
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Principles', style: JuntoStyles.header),
                _PrincipleListing(
                  data: principles,
                  showFirst: _principlesFullView,
                ),
                _principlesSeeMore()
              ],
            ),
          ),
        if (!principles.isNotEmpty) const SizedBox(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Bio / Purpose', style: JuntoStyles.header),
              const SizedBox(height: 10),
              Text(widget.group.groupData.description)
            ],
          ),
        ),
      ],
    );
  }

  Widget _principlesSeeMore() {
    if (principles.length > 1) {
      return GestureDetector(
        onTap: () {
          setState(() {
            if (_principlesFullView == false) {
              _principlesFullView = true;
            } else {
              _principlesFullView = false;
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.centerLeft,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
            ),
          ),
          child: Row(
            children: <Widget>[
              _principlesFullView
                  ? const Text('see more')
                  : const Text('collapse'),
              const SizedBox(width: 5),
              Icon(
                _principlesFullView
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up,
                size: 17,
                color: const Color(0xff555555),
              )
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildExpressionView() {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: <Widget>[
        ExpressionPreview(
          expression: expressions[0],
        ),
        ExpressionPreview(
          expression: expressions[1],
        ),
        ExpressionPreview(
          expression: expressions[2],
        ),
        ExpressionPreview(
          expression: expressions[3],
        )
      ],
    );
  }

  Widget _buildEventsView() {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: <Widget>[
        ExpressionPreview(
          expression: expressions[3],
        )
      ],
    );
  }
}

class MemberRow extends StatelessWidget {
  const MemberRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipOval(
                child: Image.asset(
                  'assets/images/junto-mobile__eric.png',
                  height: 28.0,
                  width: 28.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 5),
              ClipOval(
                child: Image.asset(
                  'assets/images/junto-mobile__riley.png',
                  height: 28.0,
                  width: 28.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 5),
              ClipOval(
                child: Image.asset(
                  'assets/images/junto-mobile__yaz.png',
                  height: 28.0,
                  width: 28.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 5),
              ClipOval(
                child: Image.asset(
                  'assets/images/junto-mobile__josh.png',
                  height: 28.0,
                  width: 28.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 5),
              ClipOval(
                child: Image.asset(
                  'assets/images/junto-mobile__dora.png',
                  height: 28.0,
                  width: 28.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 5),
              ClipOval(
                child: Image.asset(
                  'assets/images/junto-mobile__tomis.png',
                  height: 28.0,
                  width: 28.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 5),
              ClipOval(
                child: Image.asset(
                  'assets/images/junto-mobile__drea.png',
                  height: 28.0,
                  width: 28.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 5),
              ClipOval(
                child: Image.asset(
                  'assets/images/junto-mobile__leif.png',
                  height: 28.0,
                  width: 28.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            child: const Text('49 members', style: JuntoStyles.title),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

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
        child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class _PrincipleListing extends StatefulWidget {
  const _PrincipleListing({
    Key key,
    @required this.showFirst,
    @required this.data,
  }) : super(key: key);

  final bool showFirst;
  final List<Principle> data;

  @override
  __PrincipleListingState createState() => __PrincipleListingState();
}

class __PrincipleListingState extends State<_PrincipleListing> {
  @override
  Widget build(BuildContext context) {
    if (widget.showFirst) {
      return _PrincipleItem(item: widget.data.first, index: 0);
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.data.length,
        itemBuilder: (BuildContext context, int index) {
          return _PrincipleItem(
            index: index,
            item: widget.data[index],
          );
        },
      );
    }
  }
}

class _PrincipleItem extends StatelessWidget {
  const _PrincipleItem({
    Key key,
    @required this.item,
    @required this.index,
  }) : super(key: key);
  final Principle item;
  final int index;

  String get title => item.title;

  String get body => item.body;

  @override
  Widget build(BuildContext context) {
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
            (index + 1).toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xff999999),
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
                Text(
                  title,
                  style: JuntoStyles.title,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10),
                Text(body)
              ],
            ),
          )
        ],
      ),
    );
  }
}
