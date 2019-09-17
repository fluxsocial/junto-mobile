import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';

/// Takes the member's handle as an un-named param.
class MemberAppbar extends StatelessWidget {
  const MemberAppbar(this.memberHandle);

  /// User's handle to be displayed
  final String memberHandle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        iconTheme: const IconThemeData(color: Color(0xff555555)),
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  CustomIcons.back_arrow_left,
                  color: Color(0xff555555),
                  size: 24,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'sunyata',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff333333),
                  ),
                ),
              ),
              GestureDetector(                
                child: Icon(CustomIcons.more),
              )
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Color(0xffeeeeee),
                ),
              ),
            ),
          ),
        ));
  }
}
