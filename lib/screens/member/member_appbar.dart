import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/member/member_action_items.dart';

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
        iconTheme: const IconThemeData(
          color: Color(0xff555555),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 42,
                  color: Colors.transparent,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: const Icon(
                    CustomIcons.back,
                    color: Color(0xff333333),
                    size: 17,
                  ),
                ),
              ),
              Text(
                memberHandle,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff333333),
                ),
              ),
              GestureDetector(
                onTap: () {
                  MemberActionItems().buildMemberActionItems(context);
                },
                child: Container(
                  width: 42,
                  padding: const EdgeInsets.only(right: 10),
                  alignment: Alignment.centerRight,
                  color: Colors.transparent,
                  child: const Icon(CustomIcons.more),
                ),
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
