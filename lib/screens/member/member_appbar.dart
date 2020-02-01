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
              // GestureDetector(
              //   onTap: () {
              //     showModalBottomSheet(
              //       context: context,
              //       builder: (BuildContext context) => Container(
              //         color: Colors.transparent,
              //         child: MemberActionItems(),
              //       ),
              //     );
              //   },
              //   child: Container(
              //     width: 42,
              //     padding: const EdgeInsets.only(right: 10),
              //     alignment: Alignment.centerRight,
              //     color: Colors.transparent,
              //     child: Icon(CustomIcons.morevertical,
              //         color: Theme.of(context).primaryColor, size: 20),
              //   ),
              // )
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

class MemberActionItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .3,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 5,
                    width: MediaQuery.of(context).size.width * .1,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                onTap: () {},
                title: Row(
                  children: <Widget>[
                    Icon(Icons.block,
                        size: 17, color: Theme.of(context).primaryColorDark),
                    const SizedBox(width: 15),
                    Text('Block Member',
                        style: Theme.of(context).textTheme.headline5),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
