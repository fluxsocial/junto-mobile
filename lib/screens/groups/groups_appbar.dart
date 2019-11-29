import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class JuntoGroupsAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: <Widget>[Container()],
      brightness: Brightness.light,
      elevation: 0,
      titleSpacing: 0.0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(.5),
          child: Container(
        height: .5,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xffeeeeee), width: .75),
          ),
        ),
      )),
      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(.5),
      //   child: Container(
      //     height: .5,
      //     decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //           begin: Alignment.centerLeft,
      //           end: Alignment.centerRight,
      //           stops: <double>[
      //             0.1,
      //             0.9
      //           ],
      //           colors: <Color>[
      //             Theme.of(context).colorScheme.secondary,
      //             Theme.of(context).colorScheme.primary,
      //           ]),
      //     ),
      //   ),
      // ),
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    color: Colors.transparent,
                    height: 48,
                    child: Row(
                      children: <Widget>[
                        Image.asset('assets/images/junto-mobile__logo.png',
                            height: 22.0, width: 22.0),
                        const SizedBox(width: 7.5),
                        Text(
                          'GROUPS',
                          style: Theme.of(context).appBarTheme.textTheme.body1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 42,
                    padding: const EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    color: Colors.transparent,
                    child: Icon(
                      Icons.search,
                    ),
                  ),
                ),
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
                            borderRadius: BorderRadius.only(
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
