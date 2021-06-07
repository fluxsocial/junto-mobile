import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';

class ExpressionProgressIndicator extends StatelessWidget {
  const ExpressionProgressIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
        child: Center(
          child: JuntoProgressIndicator(),
        ),
      ),
    );
  }
}
