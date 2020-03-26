import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

// Junto app bar used throughout the main screens. Rendered in JuntoTemplate.
class DenAppbar extends StatefulWidget implements PreferredSizeWidget {
  const DenAppbar({Key key, @required this.heading}) : super(key: key);
  final String heading;

  @override
  Size get preferredSize => const Size.fromHeight(48.0);

  @override
  _DenAppbarState createState() => _DenAppbarState();
}

class _DenAppbarState extends State<DenAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      brightness: Theme.of(context).brightness,
      actions: <Widget>[Container()],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(.75),
        child: Container(height: .75, color: Theme.of(context).dividerColor),
      ),
      elevation: 0,
      titleSpacing: 0.0,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 10),
              color: Colors.transparent,
              height: 48,
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/junto-mobile__logo.png',
                    height: 22.0,
                    width: 22.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 7.5),
                  Text(
                    widget.heading,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) => Container(
                        color: Colors.transparent,
                        child: Container(
                          height: MediaQuery.of(context).size.height * .9,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Notifications',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text('building this last...')
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 42,
                    color: Colors.transparent,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 10),
                    child: const Icon(
                      CustomIcons.moon,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
