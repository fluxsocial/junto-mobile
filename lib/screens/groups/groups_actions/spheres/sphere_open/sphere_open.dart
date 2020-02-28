import 'package:async/async.dart' show AsyncMemoizer;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/sphere_open/sphere_open_appbar.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/sphere_open/sphere_open_members.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/tab_bar.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final GlobalKey<SphereOpenState> _keyFlexibleSpace =
      GlobalKey<SphereOpenState>();

  String _userAddress;

  @override
  void initState() {
    super.initState();
    print(widget.group.address);
    WidgetsBinding.instance.addPostFrameCallback(_getFlexibleSpaceSize);
  }

  double _flexibleHeightSpace;

  void _getFlexibleSpaceSize(_) {
    final RenderBox renderBoxFlexibleSpace =
        _keyFlexibleSpace.currentContext.findRenderObject();
    final Size sizeFlexibleSpace = renderBoxFlexibleSpace.size;
    final double heightFlexibleSpace = sizeFlexibleSpace.height;

    setState(() {
      _flexibleHeightSpace = heightFlexibleSpace;
    });
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _userAddress = prefs.getString('user_id');
    });
  }

  final AsyncMemoizer<List<ExpressionResponse>> _memoizer =
      AsyncMemoizer<List<ExpressionResponse>>();

  Future<List<ExpressionResponse>> _getGroupExpressions() async {
    return _memoizer.runOnce(
      () => Provider.of<GroupRepo>(context, listen: false).getGroupExpressions(
        widget.group.address,
        GroupExpressionQueryParams(
            creatorExpressions: true,
            directExpressions: true,
            directExpressionPaginationPosition: 0,
            creatorExpressionsPaginationPosition: 0),
      ),
    );
  }

  Future<void> _getMembers() async {
    try {
      JuntoLoader.showLoader(context);
      final List<Users> _members =
          await Provider.of<GroupRepo>(context, listen: false).getGroupMembers(
        widget.group.address,
      );
      JuntoLoader.hide();
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
      JuntoLoader.hide();
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

  final List<String> _tabs = <String>['About', 'Discussion'];

  @override
  Widget build(BuildContext context) {
    print(widget.group.address);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: SphereOpenAppbar(
          group: widget.group,
        ),
      ),
      body: DefaultTabController(
        length: _tabs.length,
        child: NestedScrollView(
          body: TabBarView(
            children: <Widget>[
              _buildAboutView(),
              if (widget.group.address != null) _buildExpressionView(),
            ],
          ),
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
                      widget.group.groupData.photo == ''
                          ? Container(
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
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            )
                          : CachedNetworkImage(
                              imageUrl: widget.group.groupData.photo,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * .3,
                              placeholder: (BuildContext context, String _) {
                                return Container(
                                    color: Theme.of(context).dividerColor,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        .3);
                              },
                              fit: BoxFit.cover),
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
                                  style: Theme.of(context).textTheme.headline4),
                            ),
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
                delegate: JuntoAppBarDelegate(
                  TabBar(
                    labelPadding: const EdgeInsets.all(0),
                    isScrollable: true,
                    labelColor: Theme.of(context).primaryColorDark,
                    labelStyle: Theme.of(context).textTheme.subtitle1,
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
        GestureDetector(
          onTap: () => _getMembers(),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: JuntoStyles.horizontalPadding,
              vertical: 15,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: .75,
                ),
              ),
            ),
            child: Container(
              child: Text(
                'Members',
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Bio / Purpose',
                  style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 10),
              Text(widget.group.groupData.description,
                  style: Theme.of(context).textTheme.caption)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpressionView() {
    return FutureBuilder<List<ExpressionResponse>>(
      future: _getGroupExpressions(),
      builder: (BuildContext context,
          AsyncSnapshot<List<ExpressionResponse>> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Transform.translate(
              offset: const Offset(0.0, -50),
              child: const Text('Hmm, something is up'),
            ),
          );
        }
        if (snapshot.hasData) {
          return ListView(
            padding: const EdgeInsets.all(0),
            children: <Widget>[
              Container(
                color: Theme.of(context).backgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * .5,
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 10,
                        right: 5,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          for (int index = 0;
                              index < snapshot.data.length + 1;
                              index++)
                            if (index == snapshot.data.length)
                              const SizedBox()
                            else if (index.isEven)
                              ExpressionPreview(
                                expression: snapshot.data[index],
                                userAddress: _userAddress,
                              )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .5,
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 5,
                        right: 10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          for (int index = 0;
                              index < snapshot.data.length + 1;
                              index++)
                            if (index == snapshot.data.length)
                              const SizedBox()
                            else if (index.isOdd)
                              ExpressionPreview(
                                expression: snapshot.data[index],
                                userAddress: _userAddress,
                              )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return Center(
          child: JuntoProgressIndicator(),
        );
      },
    );
  }
}
