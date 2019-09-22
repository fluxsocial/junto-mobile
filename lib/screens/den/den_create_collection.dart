import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';
import 'package:junto_beta_mobile/custom_icons.dart';

class DenCreateCollection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DenCreateCollectionState();
  }
}

class DenCreateCollectionState extends State<DenCreateCollection> {
  bool _collectionPublic = true;
  bool _collectionPrivate = false;

  _toggleCollectionPrivacy(privacy) {
    if (privacy == 'public') {
      setState(() {
        _collectionPublic = true;
        _collectionPrivate = false;
      });
    } else if (privacy == 'private') {
      setState(() {
        _collectionPrivate = true;
        _collectionPublic = false;
      });
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
                Text(
                  'Create collection',
                  style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff333333),
                      fontWeight: FontWeight.w700),
                ),
                GestureDetector(
                  onTap: () {
                    // create collection
                  },
                  child: const Text('create', style: JuntoStyles.body),
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
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        // padding: EdgeInsets.symmetric(vertical: 15),
                        width: MediaQuery.of(context).size.width - 20,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xffeeeeee),
                              width: .75,
                            ),
                          ),
                        ),
                        child: TextField(
                          buildCounter: (
                            BuildContext context, {
                            int currentLength,
                            int maxLength,
                            bool isFocused,
                          }) =>
                              null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Name your collection',
                            hintStyle: const TextStyle(
                                color: Color(0xff999999),
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          cursorColor: Color(0xff333333),
                          cursorWidth: 2,
                          maxLines: null,
                          style: const TextStyle(
                              color: Color(0xff333333),
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                          maxLength: 80,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xffeeeeee),
                              width: .75,
                            ),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              CustomIcons.half_lotus,
                              size: 17,
                              color: Color(0xff333333),
                            ),
                            SizedBox(width: 20),
                            Text(
                              'add expressions',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xffeeeeee),
                              width: .75,
                            ),
                          ),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Keep collection private',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(2.5),
                                    height: 28,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: _collectionPublic
                                          ? Color(0xfffeeeeee)
                                          : null,
                                      gradient: _collectionPrivate
                                          ? LinearGradient(
                                              colors: [
                                                JuntoPalette.juntoSecondary,
                                                JuntoPalette.juntoPrimary
                                              ],
                                              begin: Alignment.bottomLeft,
                                              end: Alignment.topRight,
                                            )
                                          : null,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            _toggleCollectionPrivacy('public');
                                          },
                                          child: Container(
                                            height: 28,
                                            // half width of parent container minus horizontal padding
                                            width: 27.5,
                                            decoration: BoxDecoration(
                                              color: _collectionPublic
                                                  ? Colors.white
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _toggleCollectionPrivacy('private');
                                          },
                                          child: Container(
                                            height: 28,
                                            // half width of parent container minus horizontal padding
                                            width: 27.5,
                                            decoration: BoxDecoration(
                                              color: _collectionPrivate
                                                  ? Colors.white
                                                  : Color(0xffeeeeee),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
