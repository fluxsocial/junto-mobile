import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../typography/palette.dart';
import '../../../custom_icons.dart';
import '../../../scoped_models/scoped_user.dart';
import '../../../components/expression_preview/expression_preview.dart';

class PackOpen extends StatefulWidget {
  final packTitle;
  final packUser;
  final packImage;

  PackOpen(this.packTitle, this.packUser, this.packImage);

  @override
  State<StatefulWidget> createState() {
    return PackOpenState();
  }
}

class PackOpenState extends State<PackOpen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: JuntoPalette.juntoSleek),
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(CustomIcons.back_arrow_left,
                      color: JuntoPalette.juntoSleek, size: 24),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Text(widget.packTitle,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black)),
                    ),
                    ClipOval(
                      child: Image.asset(
                        widget.packImage,
                        height: 27.0,
                        width: 27.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),

                // Icon(CustomIcons.more,
                //     color: JuntoPalette.juntoSleek, size: 24)
              ],
            ),
          ),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [
                        0.1,
                        0.9
                      ],
                      // colors: [Color(0xffeeeeee), Color(0xffeeeeee)]
                      colors: [
                        JuntoPalette.juntoPurple,
                        JuntoPalette.juntoPurpleLight
                      ]),
                ),
              )),
        ),
      ),
      body: ScopedModelDescendant<ScopedUser>(
        builder: (context, child, model) => ListView(
              // shrinkWrap: true,
              // physics: ClampingScrollPhysics(),
              children: model.collectiveExpressions
                  .map((expression) => ExpressionPreview(expression))
                  .toList(),
            ),
      ),
    );
  }
}
