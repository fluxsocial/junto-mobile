import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

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
                  child: Icon(
                    CustomIcons.back,
                    color: Theme.of(context).primaryColorDark,
                    size: 17,
                  ),
                ),
              ),
              Text(
                memberHandle.toLowerCase(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(width: 42),
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
                    width: .75, color: Theme.of(context).dividerColor),
              ),
            ),
          ),
        ));
  }
}
