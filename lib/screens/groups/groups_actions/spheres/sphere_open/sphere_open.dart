import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:junto_beta_mobile/widgets/tab_bar.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/sphere_open/sphere_open_appbar.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/sphere_open/sphere_open_members.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
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
    print(widget.group.members);
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
            // These are the contents of the tab views, below the tabs.
            children: <Widget>[
              _buildAboutView(),
              const SizedBox(),
              // _buildExpressionView(),
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
                      widget.group.groupData.photo == ''
                          ? GestureDetector(
                              onTap: () async {
                                final groupMembers =
                                    await Provider.of<GroupRepo>(context,
                                            listen: false)
                                        .getGroupMembers(widget.group.address);
                                print(groupMembers);
                              },
                              child: Container(
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
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
            child: const MemberRow(
              membersLength: 1,
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

//ignore:unused_element
  // Widget _buildExpressionView() {
  //   return FutureBuilder<List<CentralizedExpressionResponse>>(
  //     future: Provider.of<GroupRepo>(context, listen: false)
  //         .getGroupExpressions(widget.group.address, null),
  //     builder: (
  //       BuildContext context,
  //       AsyncSnapshot<List<CentralizedExpressionResponse>> snapshot,
  //     ) {
  //       if (snapshot.hasError)
  //         return Container(
  //           height: 400,
  //           alignment: Alignment.center,
  //           child: const Text(
  //             'Oops, something is wrong!',
  //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
  //           ),
  //         );
  //       if (snapshot.hasData && !snapshot.hasError) {
  //         return RefreshIndicator(
  //           onRefresh: () async => setState(() => print('refresh')),
  //           child: ListView.builder(
  //             itemCount: snapshot.data.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               return ExpressionPreview(
  //                 expression: snapshot.data[index],
  //                 userAddress: widget.userAddress,
  //               );
  //             },
  //           ),
  //         );
  //       }
  //       return Container(
  //         height: 100.0,
  //         width: 100.0,
  //         child: const Center(
  //           child: CircularProgressIndicator(),
  //         ),
  //       );
  //     },
  //   );
  // }
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
      child: Container(
        child: Text(
          'Members',
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
    );
  }
}

// Container(
//   padding: const EdgeInsets.symmetric(
//       horizontal: 10, vertical: 7.5),
//   decoration: BoxDecoration(
//     border: Border.all(
//         color: Theme.of(context).primaryColor,
//         width: 1.5),
//     borderRadius: BorderRadius.circular(25),
//   ),
//   child: Row(
//     children: <Widget>[
//       const SizedBox(width: 14),
//       Icon(CustomIcons.spheres,
//           size: 14,
//           color: Theme.of(context).primaryColor),
//       const SizedBox(width: 2),
//       Icon(Icons.keyboard_arrow_down,
//           size: 12,
//           color: Theme.of(context).primaryColor)
//     ],
//   ),
// )
