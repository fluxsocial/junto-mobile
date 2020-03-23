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
      hint: 'Toggle filters drawer',
      child: Material(
        child: IconButton(
          onPressed: () => JuntoFilterDrawer.of(context).toggle(),
          icon: Container(
            child: Image.asset('assets/images/junto-mobile__filter.png',
                height: 17, color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }
}
