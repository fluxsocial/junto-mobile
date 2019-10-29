import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/sphere.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/create_perspective/perspective_member_preview/perspective_member_preview.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:provider/provider.dart';

class SphereOpenMembers extends StatelessWidget {
  const SphereOpenMembers({
    Key key,
    @required this.users,
    @required this.group,
  }) : super(key: key);

  final List<Users> users;
  final Group group;
  static Route<dynamic> route(Group group, List<Users> users) {
    return CupertinoPageRoute<dynamic>(
      builder: (BuildContext context) {
        return SphereOpenMembers(
          users: users,
          group: group,
        );
      },
    );
  }

  Future<void> removeMember(BuildContext context, Users user) async {
    final GroupRepo groupRepo = Provider.of<GroupRepo>(context);
    try {
      await groupRepo.removeGroupMember(group.address, user.user.address);
      Navigator.pop(context);
    } on JuntoException catch (error) {
      JuntoDialog.showJuntoDialog(
        context,
        error.message,
        <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          ),
        ],
      );
    }
  }

  Future<void> _deleteMember(BuildContext context, Users user) async {
    print('User perms level ${user.permissionLevel}');
    JuntoDialog.showJuntoDialog(
      context,
      'Delete Member ${user.user.firstName}',
      <Widget>[
        FlatButton(
          onPressed: () => removeMember(context, user),
          child: const Text('Yes'),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('No'),
        ),
      ],
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
                  child: const Text(
                    'Members',
                    style: TextStyle(
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
              decoration: const BoxDecoration(
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
      body: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            final Users user = users[index];
            return PerspectiveMemberPreview(
              key: Key(user.user.address),
              onTap: () {
                Navigator.of(context).push(JuntoMember.route(user.user));
              },
              name: '${user.user.firstName} ${user.user.lastName}',
              username: user.user.username,
              showIndicator: false,
              onLongPress: () => _deleteMember(context, user),
            );
          },
        ),
      ),
    );
  }
}
