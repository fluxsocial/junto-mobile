import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/sphere.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/create_perspective/perspective_member_preview/perspective_member_preview.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/styles.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/palette.dart';

class SphereOpenMembers extends StatelessWidget {
  const SphereOpenMembers({Key key, @required this.users}) : super(key: key);

  final List<Users> users;

  static Route<dynamic> route(List<Users> users) {
    return CupertinoPageRoute<dynamic>(
      builder: (BuildContext context) {
        return SphereOpenMembers(
          users: users,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: AppBar(
            automaticallyImplyLeading: false,
            brightness: Brightness.light,
            iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
            backgroundColor: Colors.white,
            elevation: 0,
            titleSpacing: 0,
            title: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      color: Colors.white,
                      width: 38,
                      alignment: Alignment.centerLeft,
                      child: const Icon(
                        CustomIcons.back_arrow_left,
                        color: JuntoPalette.juntoSleek,
                        size: 28,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: Text(
                      'Members',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff333333),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 38,
                      color: Colors.white,
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.add,
                        size: 24,
                        color: Color(0xff333333),
                      ),
                    ),
                  )
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: JuntoPalette.juntoFade,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  

                ],
              ),
            ),
          ],
        )

        // SafeArea(
        //   child: Expanded(
        //     child: ListView.builder(
        //       shrinkWrap: true,
        //       physics: ClampingScrollPhysics(),
        //       itemCount: users.length,
        //       itemBuilder: (BuildContext context, int index) {
        //         final Users user = users[index];
        //         return InkWell(
        //           onTap: () => Navigator.of(context).push(
        //             JuntoMember.route(user.user),
        //           ),
        //           child: PerspectiveMemberPreview(
        //             key: Key(user.user.address),
        //             name: '${user.user.firstName} ${user.user.lastName}',
        //             username: user.user.username,
        //             showIndicator: false,
        //           ),
        //         );
        //       },
        //     ),
        //   ),
        // ),
        );
  }
}
