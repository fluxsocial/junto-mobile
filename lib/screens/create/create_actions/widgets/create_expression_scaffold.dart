import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_app_bar.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/drawer/filter_drawer_content.dart';

class CreateExpressionScaffold extends StatelessWidget {
  const CreateExpressionScaffold({
    Key key,
    this.child,
    this.onNext,
    this.showBottomNav = true,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onNext;
  final bool showBottomNav;

  @override
  Widget build(BuildContext context) {
    // TODO(dominik): wrap with bloc
    return Scaffold(
      body: JuntoFilterDrawer(
        leftDrawer: const FilterDrawerContent('Collective'),
        rightMenu: JuntoDrawer(),
        scaffold: Scaffold(
          appBar: CreateAppBar(
            expressionType: ExpressionType.dynamic,
            onNext: onNext,
          ),
          resizeToAvoidBottomPadding: false,
          floatingActionButton: showBottomNav ? const CreateBottomNav() : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: Column(
            children: <Widget>[child],
          ),
        ),
      ),
    );
  }
}
