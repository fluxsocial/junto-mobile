import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_open/sphere_open_appbar.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_open/sphere_open_facilitators.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_open/sphere_open_members.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/fabs/expression_center_fab.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview.dart';
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

  List<CentralizedExpressionResponse> expressions;

  final GlobalKey<SphereOpenState> _keyFlexibleSpace =
      GlobalKey<SphereOpenState>();

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

    WidgetsBinding.instance.addPostFrameCallback(_getFlexibleSpaceSize);
  }

  double _flexibleHeightSpace;

  void _getFlexibleSpaceSize(_) {
    final RenderBox renderBoxFlexibleSpace =
        _keyFlexibleSpace.currentContext.findRenderObject();
    final Size sizeFlexibleSpace = renderBoxFlexibleSpace.size;
    final double heightFlexibleSpace = sizeFlexibleSpace.height;
    print(heightFlexibleSpace);

    setState(() {
      _flexibleHeightSpace = heightFlexibleSpace;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    expressions = Provider.of<ExpressionRepo>(context).collectiveExpressions;
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
    try {
      JuntoOverlay.showLoader(context);
      final List<Users> _members =
          await Provider.of<GroupRepo>(context).getGroupMembers(
        widget.group.address,
      );
      JuntoOverlay.hide();
      Navigator.push(
        context,
        CupertinoPageRoute<dynamic>(
          builder: (BuildContext context) {
            return SphereOpenMembers(
              group: widget.group,
              users: _members,
            );
          },
        ),
      );
    } on JuntoException catch (error) {
      JuntoOverlay.hide();
      JuntoDialog.showJuntoDialog(
        context,
        error.message,
        <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          )
        ],
      );
    }
  }

  final List<String> _tabs = <String>['About', 'Discussion', 'Events'];

  List<Principle> principles = <Principle>[
    const Principle(
      title: 'Be a nice person because nice people get chocolate',
      body: 'Engage with empathy and respect for one another. We are more than '
          'viewpoints that may oppose each other at times :)',
    ),
    const Principle(
        title: 'All walks of life',
        body: 'This is a communal space for all walks of life'),
  ];

  bool _principlesFullView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: ExpressionCenterFAB(
          expressionLayer: widget.group.groupData.name,
          address: widget.group.address,
          expressionContext: ExpressionContext.Group,
        ),
      ),
      body: DefaultTabController(
        length: _tabs.length,
        child: NestedScrollView(
          body: TabBarView(
            // These are the contents of the tab views, below the tabs.
            children: <Widget>[
              _buildAboutView(),
              _buildExpressionView(),
              _buildEventsView()
            ],
          ),
          controller: _hideFABController,
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                brightness: Brightness.light,
                automaticallyImplyLeading: false,
                primary: false,
                actions: const <Widget>[SizedBox(height: 0, width: 0)],
                backgroundColor: Theme.of(context).colorScheme.background,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * .3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: const <double>[0.2, 0.9],
                            colors: <Color>[
                              Theme.of(context).colorScheme.secondary,
                              Theme.of(context).colorScheme.primary
                            ],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(CustomIcons.spheres,
                            size: 60,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      Container(
                        key: _keyFlexibleSpace,
                        padding: const EdgeInsets.symmetric(
                            horizontal: JuntoStyles.horizontalPadding,
                            vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * .7,
                              child: Text(widget.group.groupData.name,
                                  style: Theme.of(context).textTheme.display1),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7.5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 1.5),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(width: 14),
                                  Icon(CustomIcons.spheres,
                                      size: 14,
                                      color: Theme.of(context).primaryColor),
                                  const SizedBox(width: 2),
                                  Icon(Icons.keyboard_arrow_down,
                                      size: 12,
                                      color: Theme.of(context).primaryColor)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                expandedHeight: _flexibleHeightSpace == null
                    ? 10000
                    : MediaQuery.of(context).size.height * .3 +
                        _flexibleHeightSpace,
                forceElevated: false,
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelPadding: const EdgeInsets.all(0),
                    isScrollable: true,
                    labelColor: Theme.of(context).primaryColorDark,
                    labelStyle: Theme.of(context).textTheme.subhead,
                    indicatorWeight: 0.0001,
                    tabs: <Widget>[
                      for (String name in _tabs)
                        Container(
                          margin: const EdgeInsets.only(right: 24),
                          color: Theme.of(context).colorScheme.background,
                          child: Tab(
                            text: name,
                          ),
                        ),
                    ],
                  ),
                ),
              )
            ];
          },
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
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: .75,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () => _getMembers(),
                child: MemberRow(
                  membersLength:
                      widget.group.members + widget.group.facilitators,
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute<dynamic>(
                builder: (BuildContext context) => const SphereOpenFacilitators(
                  users: <Users>[],
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
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
                        children: <Widget>[
                          Text('Facilitators',
                              style: Theme.of(context).textTheme.title),
                          const SizedBox(height: 10),
                          Text(
                              '${widget.group.creator} and ${widget.group.facilitators - 0} others',
                              style: Theme.of(context).textTheme.body2),
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
                Text('Principles', style: Theme.of(context).textTheme.title),
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
              Text('Bio / Purpose', style: Theme.of(context).textTheme.title),
              const SizedBox(height: 10),
              Text(widget.group.groupData.description,
                  style: Theme.of(context).textTheme.body2)
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
          decoration: BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(color: Theme.of(context).dividerColor, width: .75),
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
                color: Theme.of(context).primaryColor,
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
    return FutureBuilder<List<CentralizedExpressionResponse>>(
      future: Provider.of<GroupRepo>(context)
          .getGroupExpressions(widget.group.address, null),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<CentralizedExpressionResponse>> snapshot,
      ) {
        if (snapshot.hasError)
          return Container(
            height: 400,
            alignment: Alignment.center,
            child: const Text(
              'Oops, something is wrong!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          );
        if (snapshot.hasData && !snapshot.hasError) {
          return RefreshIndicator(
            onRefresh: () async => setState(() => print('refresh')),
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ExpressionPreview(
                  expression: snapshot.data[index],
                );
              },
            ),
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
    );
  }

  Widget _buildEventsView() {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: const <Widget>[Text('Events')],
    );
  }
}

class MemberRow extends StatelessWidget {
  const MemberRow({
    Key key,
    @required this.membersLength,
  }) : super(key: key);
  final int membersLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
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
            child: Text(
              '$membersLength members',
              style: Theme.of(context).textTheme.subtitle,
            ),
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
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border(
            bottom:
                BorderSide(color: Theme.of(context).dividerColor, width: .5),
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
        physics: const ClampingScrollPhysics(),
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
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: .75),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            (index + 1).toString(),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          const SizedBox(width: 15),
          Container(
            height: 17,
            decoration: BoxDecoration(
              border: Border(
                right:
                    BorderSide(color: Theme.of(context).dividerColor, width: 2),
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
                  style: Theme.of(context).textTheme.subtitle,
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
