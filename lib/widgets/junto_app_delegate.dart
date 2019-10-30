import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/screens/den/den_expanded.dart';

class JuntoDenAppbar extends StatefulWidget {
  const JuntoDenAppbar({
    Key key,
    @required this.handle,
    @required this.name,
    @required this.profilePicture,
    @required this.bio,
  }) : super(key: key);

  final String handle;
  final String name;
  final String profilePicture;
  final String bio;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return JuntoDenAppbarState();
  }
}

class JuntoDenAppbarState extends State<JuntoDenAppbar> {
  final GlobalKey<JuntoDenAppbarState> _keyFlexibleSpaceBio =
      GlobalKey<JuntoDenAppbarState>();

  final GlobalKey<JuntoDenAppbarState> _keyFlexibleSpaceName =
      GlobalKey<JuntoDenAppbarState>();

  double _flexibleHeightSpace;
  @override
  void initState() {
    super.initState();

    print('init');
    WidgetsBinding.instance.addPostFrameCallback(_getFlexibleSpaceSize);
  }

  void _getFlexibleSpaceSize(_) {
    final RenderBox renderBoxFlexibleSpaceBio =
        _keyFlexibleSpaceBio.currentContext.findRenderObject();
    final Size sizeFlexibleSpaceBio = renderBoxFlexibleSpaceBio.size;
    final double heightFlexibleSpaceBio = sizeFlexibleSpaceBio.height;
    print(heightFlexibleSpaceBio);

    final RenderBox renderBoxFlexibleSpaceName =
        _keyFlexibleSpaceName.currentContext.findRenderObject();
    final Size sizeFlexibleSpaceName = renderBoxFlexibleSpaceName.size;
    final double heightFlexibleSpaceName = sizeFlexibleSpaceName.height;
    print(heightFlexibleSpaceName);

    setState(() {
      // _flexibleHeightSpace = name/title row height + bio/more info height +
      // background cover size + profile picture row height
      _flexibleHeightSpace = heightFlexibleSpaceName +
          heightFlexibleSpaceBio +
          MediaQuery.of(context).size.height * .2 +
          72 +
          2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
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
              height: MediaQuery.of(context).size.height * .2,
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
            ),
            Transform.translate(
              offset: const Offset(0.0, -18.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute<dynamic>(
                            builder: (BuildContext context) => DenExpanded(
                              handle: widget.handle,
                              name: widget.name,
                              profilePicture: widget.profilePicture,
                              bio: widget.bio,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // color: Colors.blue,
                          border: Border.all(
                            width: 3.0,
                            color: Colors.white,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__eric.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0.0, 9.0),
                      child: GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        child: const Icon(CustomIcons.more, size: 24),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Transform.translate(
                offset: Offset(0.0, -18.0),
                child: Container(
                  key: _keyFlexibleSpaceName,
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // name,
                        'Eric Yang',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff333333),
                        ),
                      ),
                      const SizedBox(height: 2.5),
                      Text(
                        // title,
                        'Founder/Executive Director at Junto',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff777777),
                        ),
                      ),
                    ],
                  ),
                )),
            Transform.translate(
              offset: const Offset(0.0, -18.0),
              child: Container(
                key: _keyFlexibleSpaceBio,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * .66 - 30,
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          "To a mind that is still, the whole universe surrenders.",
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                  color: Color(0xffeeeeee), width: 1),
                            ),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Image.asset(
                                          'assets/images/junto-mobile__location.png',
                                          height: 14,
                                          color: Color(0xff999999)),
                                      const SizedBox(width: 5),
                                      Flexible(
                                        child: const Text(
                                          'Spirit in the realm of metaphysical ashkana hebrew textx',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Color(0xff999999),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/junto-mobile__link.png',
                                        height: 14,
                                        color: const Color(0xff999999),
                                      ),
                                      const SizedBox(width: 5),
                                      Flexible(
                                        child: const Text(
                                          'sirxmixalotwebsitedomainhellooooos.com',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: JuntoPalette.juntoPrimary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
      expandedHeight:
          _flexibleHeightSpace == null ? 10000 : _flexibleHeightSpace,
      forceElevated: false,
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

// Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: <Widget>[
//       Container(
//         margin: const EdgeInsets.only(right: 15),
//         child: Row(
//           children: <Widget>[
//             Image.asset(
//               'assets/images/junto-mobile__location.png',
//               height: 17,
//               color: JuntoPalette.juntoSleek,
//             ),
//             const SizedBox(width: 5),
//             const Text(
//               'Spirit',
//               style: TextStyle(
//                 color: JuntoPalette.juntoSleek,
//               ),
//             ),
//           ],
//         ),
//       ),
//       const SizedBox(height: 10),
//       Container(
//         child: Row(
//           children: <Widget>[
//             Image.asset(
//               'assets/images/junto-mobile__link.png',
//               height: 17,
//               color: JuntoPalette.juntoSleek,
//             ),
//             const SizedBox(width: 5),
//             const Text(
//               'junto.foundation',
//               style: TextStyle(
//                   color: JuntoPalette.juntoPrimary),
//             )
//           ],
//         ),
//       ),
//     ]),
