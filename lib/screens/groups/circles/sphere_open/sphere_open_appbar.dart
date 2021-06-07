import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/theme/custom_icons.dart';
import 'package:junto_beta_mobile/app/theme/palette.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/appbar/notifications_lunar_icon.dart';
import 'package:junto_beta_mobile/widgets/appbar/global_invite_icon.dart';
import 'package:junto_beta_mobile/widgets/appbar/global_search_icon.dart';

class SphereOpenAppbar extends StatelessWidget {
  const SphereOpenAppbar({
    Key key,
    @required this.group,
    @required this.onBack,
  }) : super(key: key);

  final Group group;
  final Function onBack;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: <Widget>[Container()],
      brightness: Theme.of(context).brightness,
      iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
      elevation: 0,
      titleSpacing: 0,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      if (onBack != null) {
                        onBack();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      color: Colors.transparent,
                      height: 38,
                      width: 38,
                      padding: const EdgeInsets.only(
                        left: 10,
                        bottom: 2.5,
                      ),
                      child: Icon(
                        CustomIcons.back,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Text(
                    'c/${group.groupData.sphereHandle}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  GlobalInviteIcon(),
                  GlobalSearchIcon(),
                  NotificationsLunarIcon(),
                ],
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
    );
  }
}
