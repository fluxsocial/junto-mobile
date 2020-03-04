import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class JuntoDenSliverAppbar extends StatefulWidget {
  const JuntoDenSliverAppbar(
      {Key key, @required this.profile, @required this.currentTheme})
      : super(key: key);

  final UserData profile;
  final String currentTheme;

  @override
  State<StatefulWidget> createState() {
    return JuntoDenSliverAppbarState();
  }
}

class JuntoDenSliverAppbarState extends State<JuntoDenSliverAppbar> {
  double _flexibleHeightSpace;
  final GlobalKey<JuntoDenSliverAppbarState> _keyFlexibleSpace =
      GlobalKey<JuntoDenSliverAppbarState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_getFlexibleSpaceSize);
  }

  void _getFlexibleSpaceSize(_) {
    final RenderBox renderBoxFlexibleSpace =
        _keyFlexibleSpace.currentContext.findRenderObject();
    final Size sizeFlexibleSpace = renderBoxFlexibleSpace.size;
    final double heightFlexibleSpace = sizeFlexibleSpace.height;

    setState(() {
      _flexibleHeightSpace = heightFlexibleSpace;
    });
  }

  String _getBackgroundImageAsset() {
    if (widget.currentTheme == 'rainbow' ||
        widget.currentTheme == 'rainbow-night') {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    } else if (widget.currentTheme == 'aqueous' ||
        widget.currentTheme == 'aqueous-night') {
      return 'assets/images/junto-mobile__themes--aqueous.png';
    } else if (widget.currentTheme == 'royal' ||
        widget.currentTheme == 'royal-night') {
      return 'assets/images/junto-mobile__themes--royal.png';
    } else {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    }
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
        background: Stack(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .2,
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const <double>[0.1, 0.9],
                        colors: <Color>[
                          Theme.of(context).colorScheme.secondaryVariant,
                          Theme.of(context).colorScheme.primaryVariant,
                        ],
                      ),
                      border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).dividerColor, width: .75),
                      ),
                    ),
                  ),
                  Container(
                    key: _keyFlexibleSpace,
                    margin: const EdgeInsets.only(top: 30),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              widget.profile.user.name,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 1.5),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text('edit')),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * .2 - 30,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ClipOval(
                  child: Container(
                    height: 60,
                    width: 60,
                    child: CachedNetworkImage(
                      placeholder: (BuildContext context, String _) {
                        return Container(
                          height: 60,
                          width: 60,
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
                        );
                      },
                      imageUrl: widget.profile.user.profilePicture[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      expandedHeight: _flexibleHeightSpace == null
          ? 1000
          : _flexibleHeightSpace + MediaQuery.of(context).size.height * .2,
      forceElevated: false,
    );
  }
}
