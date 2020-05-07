import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_app_bar.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/app/screens.dart';

class CreateExpressionScaffold extends StatelessWidget {
  const CreateExpressionScaffold({
    Key key,
    this.child,
    this.onNext,
    this.showBottomNav = true,
    @required this.expressionType,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onNext;
  final bool showBottomNav;
  final ExpressionType expressionType;

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: Scaffold(
        body: JuntoFilterDrawer(
          leftDrawer: null,
          rightMenu: JuntoDrawer(),
          scaffold: Scaffold(
            appBar: CreateAppBar(
              expressionType: expressionType,
              onNext: onNext,
            ),
            resizeToAvoidBottomPadding: false,
            resizeToAvoidBottomInset: false,
            floatingActionButton: showBottomNav
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: BottomNav(
                      actionsVisible: false,
                      onLeftButtonTap: () => Navigator.pop(
                        context,
                        expressionType,
                      ),
                      source: Screen.create,
                    ),
                  )
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: Column(
              children: <Widget>[child],
            ),
          ),
        ),
      ),
    );
  }
}
