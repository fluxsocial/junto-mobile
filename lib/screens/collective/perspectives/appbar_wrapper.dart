import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/appbar/collective_appbar.dart';

class AppBarWrapper extends StatelessWidget {
  const AppBarWrapper({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: CollectiveAppBar(
        expandedHeight: MediaQuery.of(context).size.height * .1 + 50,
        appbarTitle: title,
      ),
      pinned: false,
      floating: true,
    );
  }
}
