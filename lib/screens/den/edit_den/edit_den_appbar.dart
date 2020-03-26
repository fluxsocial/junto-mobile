import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class EditDenAppbar extends StatelessWidget {
  const EditDenAppbar({this.updateUser});

  final Function updateUser;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      iconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
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
                padding: const EdgeInsets.only(left: 10),
                width: 42,
                height: 42,
                alignment: Alignment.centerLeft,
                color: Colors.transparent,
                child: Icon(
                  CustomIcons.back,
                  color: Theme.of(context).primaryColorDark,
                  size: 17,
                ),
              ),
            ),
            Container(
              child: Text(
                'Edit Den',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            GestureDetector(
              onTap: updateUser,
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                alignment: Alignment.centerRight,
                color: Colors.transparent,
                width: 42,
                height: 42,
                child: Text(
                  'Save',
                  style: Theme.of(context).textTheme.bodyText1,
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
