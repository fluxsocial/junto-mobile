import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_drawer.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_open_appbar.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_open_public.dart';
import 'package:junto_beta_mobile/widgets/fabs/expression_center_fab.dart';

class PackOpen extends StatefulWidget {
  const PackOpen({
    Key key,
    @required this.pack,
  }) : super(key: key);

  final Group pack;

  @override
  State<StatefulWidget> createState() {
    return PackOpenState();
  }
}

class PackOpenState extends State<PackOpen> {
  // Controller for PageView
  PageController controller;
  int _currentIndex = 0;
  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(45),
            child: PackOpenAppbar(pack: widget.pack),
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
            child: const ExpressionCenterFAB(expressionLayer: 'my pack'),
          ),
          endDrawer: PackDrawer(
            pack: widget.pack,
          ),
          body: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Theme.of(context).dividerColor, width: .75),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * .5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(CustomIcons.lotus,
                              size: 20,
                              color: _currentIndex == 0
                                  ? Theme.of(context).primaryColorDark
                                  : Theme.of(context).primaryColorLight),
                          const SizedBox(width: 10),
                          Text('Public',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: _currentIndex == 0
                                      ? Theme.of(context).primaryColorDark
                                      : Theme.of(context).primaryColorLight))
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(CustomIcons.packs,
                              size: 17,
                              color: _currentIndex == 1
                                  ? Theme.of(context).primaryColorDark
                                  : Theme.of(context).primaryColorLight),
                          const SizedBox(width: 10),
                          Text('Pack',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: _currentIndex == 1
                                      ? Theme.of(context).primaryColorDark
                                      : Theme.of(context).primaryColorLight))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: controller,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  children: <Widget>[
                    PackOpenPublic(fabVisible: _isVisible),
                    Center(
                      child: Text('private pack expressions'),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
