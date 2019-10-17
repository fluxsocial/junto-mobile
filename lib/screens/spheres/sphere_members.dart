import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/sphere.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/create_perspective/perspective_member_preview/perspective_member_preview.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/styles.dart';

class GroupMembers extends StatelessWidget {
  const GroupMembers({
    Key key,
    @required this.users,
    this.groupName = 'Sphere Members',
  }) : super(key: key);

  final List<Users> users;
  final String groupName;

  static Route<dynamic> route(List<Users> users, {String name}) {
    return CupertinoPageRoute<dynamic>(
      builder: (BuildContext context) {
        return GroupMembers(
          users: users,
          groupName: name,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          groupName ?? '',
          style: JuntoStyles.appbarTitle,
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              final Users user = users[index];
              return PerspectiveMemberPreview(
                key: Key(user.user.address),
                name: '${user.user.firstName}  ${user.user.lastName}',
                username: user.user.username,
                showIndicator: true,
                indicatorColor: user.permissionLevel == 'Admin'
                    ? Colors.greenAccent
                    : Colors.white,
                onTap: () => Navigator.of(context).push(
                      JuntoMember.route(user.user),
                    ),
              );
            },
          ),
        ),
      ),
    );
  }
}
