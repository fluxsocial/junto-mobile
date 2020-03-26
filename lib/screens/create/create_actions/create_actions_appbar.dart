import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class CreateActionsAppbar extends StatelessWidget {
  const CreateActionsAppbar({
    Key key,
    @required this.onCreateTap,
  }) : super(key: key);

  final VoidCallback onCreateTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      brightness: Theme.of(context).brightness,
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
                height: 42,
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  CustomIcons.back,
                  color: Theme.of(context).primaryColorDark,
                  size: 17,
                ),
              ),
            ),
            GestureDetector(
              onTap: onCreateTap,
              child: Container(
                height: 42,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  'create',
                  style: Theme.of(context).textTheme.caption,
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
                color: Theme.of(context).dividerColor,
                width: .75,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
