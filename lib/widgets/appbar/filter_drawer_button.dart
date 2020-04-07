import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';

class FilterDrawerButton extends StatelessWidget {
  const FilterDrawerButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      hint: 'Toggle filter drawer',
      child: GestureDetector(
        onTap: () => JuntoFilterDrawer.of(context).toggle(),
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            'assets/images/junto-mobile__filter.png',
            height: 17,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
