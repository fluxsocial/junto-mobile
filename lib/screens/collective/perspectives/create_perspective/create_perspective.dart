import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/typography/palette.dart';

class CreatePerspective extends StatelessWidget {
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
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  CustomIcons.back_arrow_left,
                  color: JuntoPalette.juntoSleek,
                  size: 24,
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: const Color(0xffeeeeee),
            ),
          ),
        ),
      ),
      body: Column(
        children: const <Widget>[],
      ),
    );
  }
}
