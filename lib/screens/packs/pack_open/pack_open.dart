import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_drawer.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_open_appbar.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_open_private.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_open_public.dart';
import 'package:junto_beta_mobile/widgets/create_fab/create_fab.dart';


class PackOpen extends StatefulWidget {
  const PackOpen(this.packTitle, this.packUser, this.packImage);

  final dynamic packTitle;
  final dynamic packUser;
  final dynamic packImage;

  @override
  State<StatefulWidget> createState() {
    return PackOpenState();
  }
}

class PackOpenState extends State<PackOpen> {
  // Controller for PageView
  PageController controller;
  bool publicActive = true;
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
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: PackOpenAppbar(
            packTitle: widget.packTitle,
            packUser: widget.packUser,
            packImage: widget.packImage,
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CreateFAB(
              sphereHandle: widget.packTitle,
              isVisible: _isVisible,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        endDrawer: PackDrawer(),
        body: Column(
          children: <Widget>[
            Container(
                padding: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xffeeeeee),
                      width: .75,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        controller.jumpToPage(0);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        width: MediaQuery.of(context).size.width * .5,
                        child: Icon(
                          CustomIcons.half_lotus,
                          size: 17,
                          color: publicActive
                              ? const Color(0xff333333)
                              : const Color(0xff999999),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.jumpToPage(1);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        width: MediaQuery.of(context).size.width * .5,
                        child: RotatedBox(
                          quarterTurns: 2,
                          child: Icon(
                            CustomIcons.triangle,
                            size: 17,
                            color: publicActive
                                ? const Color(0xff999999)
                                : const Color(0xff333333),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (int index) {
                  if (index == 0) {
                    setState(() {
                      publicActive = true;
                    });
                  } else if (index == 1) {
                    setState(() {
                      publicActive = false;
                    });
                  }
                },
                children: <Widget>[
                  PackOpenPublic(
                    fabVisible: _isVisible,
                  ),
                  PackOpenPrivate(
                    fabVisible: _isVisible,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
