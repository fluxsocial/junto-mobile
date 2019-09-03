import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/components/create_fab/create_fab.dart';
import 'package:junto_beta_mobile/components/utils/hide_fab.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_open/sphere_open_appbar/sphere_open_appbar.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';

class SphereOpen extends StatefulWidget {
  const SphereOpen({
    Key key,
    @required this.sphereTitle,
    @required this.sphereImage,
    @required this.sphereMembers,
    @required this.sphereHandle,
    @required this.sphereDescription,
  }) : super(key: key);

  final String sphereTitle;
  final String sphereImage;
  final String sphereMembers;
  final String sphereHandle;
  final String sphereDescription;

  @override
  State<StatefulWidget> createState() {
    return SphereOpenState();
  }
}

class SphereOpenState extends State<SphereOpen> with HideFab {
  ValueNotifier<bool> isVisible = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: SphereOpenAppbar(
          widget.sphereHandle,
        ),
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: isVisible,
          builder: (BuildContext context, bool value, _) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: value ? 1.0 : 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CreateFAB(
                  sphereHandle: widget.sphereHandle,
                  isVisible: isVisible,
                ),
              ),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: ListView(
        children: <Widget>[
          Container(
            constraints: const BoxConstraints.expand(height: 200),
            child: Image.asset(
              widget.sphereImage,
              fit: BoxFit.cover,
            ),
          ),
          Container(
              padding: const EdgeInsets.symmetric(
                horizontal: JuntoStyles.horizontalPadding,
                vertical: 15,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: JuntoPalette.juntoFade,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(widget.sphereTitle,
                                style: JuntoStyles.header),
                          ),
                          Container(
                            child: Text(widget.sphereMembers + ' members',
                                style: JuntoStyles.title),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: Text(widget.sphereDescription,
                        textAlign: TextAlign.start, style: JuntoStyles.body),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
