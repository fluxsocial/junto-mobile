import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/den/den_create_subcollection.dart';

class DenCollectionOpen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DenCollectionOpenState();
}

class DenCollectionOpenState extends State<DenCollectionOpen> {
  bool expressionsActive;
  bool subcollectionActive;

  @override
  void initState() {
    super.initState();

    expressionsActive = true;
    subcollectionActive = false;
  }

  void _toggleDomain(String domain) {
    if (domain == 'expressions') {
      setState(() {
        expressionsActive = true;
        subcollectionActive = false;
      });
    } else if (domain == 'subcollection') {
      setState(() {
        expressionsActive = false;
        subcollectionActive = true;
      });
    }
  }

// ignore: unused_element
  Widget _buildCollectionList() {
    if (expressionsActive) {
      return ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: const <Widget>[SizedBox()],
      );
    } else if (subcollectionActive == true) {
      return ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: const <Widget>[Text('subcollection')],
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          iconTheme: const IconThemeData(
            color: JuntoPalette.juntoSleek,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          title: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: JuntoStyles.horizontalPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    CustomIcons.back_arrow_left,
                    color: JuntoPalette.juntoSleek,
                    size: 24,
                  ),
                ),
                // Text(
                //   'collection',
                //   style: TextStyle(
                //       fontSize: 14,
                //       color: Color(0xff333333),
                //       fontWeight: FontWeight.w700),
                // ),
                GestureDetector(
                  onTap: () {
                    // create collection
                  },
                  child: const Icon(
                    CustomIcons.more,
                    size: 20,
                    color: Color(0xff333333),
                  ),
                )
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: JuntoPalette.juntoFade,
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Anbu',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(2.5),
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xffeeeeee),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    _toggleDomain('expressions');
                                  },
                                  child: Container(
                                    height: 30,
                                    // half width of parent container minus horizontal padding
                                    width: 37.5,
                                    decoration: BoxDecoration(
                                      color: expressionsActive
                                          ? Colors.white
                                          : const Color(0xffeeeeee),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Icon(
                                      CustomIcons.half_lotus,
                                      size: 12,
                                      color: expressionsActive
                                          ? const Color(0xff555555)
                                          : const Color(0xff999999),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _toggleDomain('subcollection');
                                  },
                                  child: Container(
                                    height: 30,
                                    // half width of parent container minus horizontal padding
                                    width: 37.5,
                                    decoration: BoxDecoration(
                                      color: subcollectionActive
                                          ? Colors.white
                                          : const Color(0xffeeeeee),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Icon(
                                      Icons.collections,
                                      size: 12,
                                      color: subcollectionActive
                                          ? const Color(0xff555555)
                                          : const Color(0xff999999),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subcollectionActive
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute<dynamic>(
                                        builder: (BuildContext context) {
                                          return DenCreateSubcollection();
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 38,
                                    alignment: Alignment.centerRight,
                                    child: const Icon(
                                      Icons.add,
                                      size: 20,
                                      color: Color(0xff555555),
                                    ),
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ],
                  ),
                ),
                // subcollectionActive
                //     ? GestureDetector(
                //         onTap: () {
                //           Navigator.push(
                //             context,
                //             CupertinoPageRoute(
                //               builder: (context) => DenCreateSubcollection(),
                //             ),
                //           );
                //         },
                //         child: Container(
                //           decoration: BoxDecoration(
                //             border: Border(
                //               bottom: BorderSide(
                //                 color: Color(0xffeeeeee),
                //                 width: .75,
                //               ),
                //               top: BorderSide(
                //                 color: Color(0xffeeeeee),
                //                 width: .75,
                //               ),
                //             ),
                //           ),
                //           padding: EdgeInsets.symmetric(
                //               vertical: 20, horizontal: 10),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: <Widget>[
                //               Text(
                //                 'Create subcollection',
                //                 style: TextStyle(
                //                     fontSize: 14, fontWeight: FontWeight.w500),
                //               ),
                //               Icon(
                //                 Icons.add,
                //                 size: 17,
                //                 color: Color(0xff555555),
                //               )
                //             ],
                //           ),
                //         ),
                //       )
                //     : SizedBox(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
