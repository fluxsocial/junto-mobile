import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/screens/global_search/global_search.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';

// Junto app bar used throughout the main screens. Rendered in JuntoTemplate.
class JuntoAppBar extends StatelessWidget implements PreferredSizeWidget {
  JuntoAppBar({
    Key key,
    @required this.juntoAppBarTitle,
  }) : super(key: key);

  final String juntoAppBarTitle;

  @override
  Size get preferredSize => const Size.fromHeight(48.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      actions: <Widget>[Container()],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(.75),
        child: Container(
          height: .75,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: <double>[
                  0.1,
                  0.9
                ],
                colors: <Color>[
                  JuntoPalette.juntoSecondary,
                  JuntoPalette.juntoPrimary
                ]),
          ),
        ),
      ),
      brightness: Brightness.light,
      elevation: 0,
      titleSpacing: 0.0,
      title: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: JuntoStyles.horizontalPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Builder(
              builder: (BuildContext context) {
                return Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Image.asset('assets/images/junto-mobile__logo.png',
                          height: 22.0, width: 22.0),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => Container(
                            color: Color(0xff737373),
                            child: Container(
                              height: MediaQuery.of(context).size.height * .9,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'Edit Perspective',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff333333),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                      'This modal will enable you to edit your perspective. This includes adding/removing members, changing the name, deleting the perspective, and so on. You will also be able to view the list of members, etc.')
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 7.5),
                        child: Text(juntoAppBarTitle,
                            style: JuntoStyles.appbarTitle),
                      ),
                    )
                  ],
                );
              },
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute<dynamic>(
                        builder: (BuildContext context) => GlobalSearch(),
                      ),
                    );
                  },
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => Container(
                          color: Color(0xff737373),
                          child: Container(
                            height: MediaQuery.of(context).size.height * .9,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Members',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff333333),
                                      ),
                                    ),
                                    SizedBox(width: 25),
                                    Text(
                                      'Spheres',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff999999)),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          20,
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
                                          hintText: 'Search members',
                                          hintStyle: const TextStyle(
                                              color: Color(0xff999999),
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        cursorColor: Color(0xff333333),
                                        cursorWidth: 2,
                                        maxLines: null,
                                        style: const TextStyle(
                                            color: Color(0xff333333),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                        maxLength: 80,
                                        textInputAction: TextInputAction.done,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      child: Icon(Icons.search,
                          color: JuntoPalette.juntoSleek,
                          size: JuntoStyles.appbarIcon),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => Container(
                        color: Color(0xff737373),
                        child: Container(
                          height: MediaQuery.of(context).size.height * .9,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Notifications',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff333333),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text('building this last...')
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 7.5),
                    child: Icon(CustomIcons.moon,
                        color: JuntoPalette.juntoSleek,
                        size: JuntoStyles.appbarIcon),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
