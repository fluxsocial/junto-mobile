import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/models/sphere.dart';

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
            elevation: 0,
            titleSpacing: 0,
            title: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.transparent,
                      width: 42,
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        CustomIcons.back,
                        color: Theme.of(context).primaryColorDark,
                        size: 17,
                      ),
                    ),
                  ),
                  Container(
                    child: Text('Members',
                        style: Theme.of(context).textTheme.subhead),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      width: 42,
                      color: Colors.transparent,
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.add,
                        size: 24,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  )
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(.75),
              child: Container(
                height: .75,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: .75,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: const <Widget>[],
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
