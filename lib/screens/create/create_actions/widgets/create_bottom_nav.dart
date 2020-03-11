import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';

class CreateBottomNav extends StatelessWidget {
  const CreateBottomNav({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: BottomNav(
        actionsVisible: false,
        screen: 'create',
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
