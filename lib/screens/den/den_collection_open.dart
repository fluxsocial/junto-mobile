import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';
import 'package:junto_beta_mobile/custom_icons.dart';

class DenCollectionOpen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DenCollectionOpenState();
  }
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

  _toggleDomain(domain) {
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

  _buildCollectionList() {
    if (expressionsActive) {
      return ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: <Widget>[SizedBox()],
      );
    } else if (subcollectionActive == true) {
      return ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: <Widget>[Text('subcollection')],
      );
    } else {
      return SizedBox();
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
                  child: Icon(
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Anbu',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(2.5),
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Color(0xfffeeeeee),
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
                                          : Color(0xffeeeeee),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Icon(
                                      CustomIcons.half_lotus,
                                      size: 12,
                                      color: expressionsActive
                                          ? Color(0xff555555)
                                          : Color(0xff999999),
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
                                          : Color(0xffeeeeee),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Icon(
                                      Icons.collections,
                                      size: 12,
                                      color: subcollectionActive
                                          ? Color(0xff555555)
                                          : Color(0xff999999),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                subcollectionActive
                    ? GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffeeeeee),
                                width: .75,
                              ),
                              top: BorderSide(
                                color: Color(0xffeeeeee),
                                width: .75,
                              ),                              
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Create subcollection',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              Icon(
                                Icons.add,
                                size: 17,
                                color: Color(0xff555555),
                              )
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
