import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ExpressionScrollRefresh extends StatefulWidget {
  ExpressionScrollRefresh({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _ExpressionScrollRefreshState createState() =>
      _ExpressionScrollRefreshState();
}

class _ExpressionScrollRefreshState extends State<ExpressionScrollRefresh>
    with TickerProviderStateMixin {
  Completer<void> refreshCompleter;

  @override
  void initState() {
    super.initState();
    refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CollectiveBloc, CollectiveState>(
      listener: _blocListener,
      child: CustomRefreshIndicator(
        offsetToArmed: 25,
        onRefresh: () {
          context.bloc<CollectiveBloc>().add(RefreshCollective());
          return refreshCompleter.future;
        },
        // onRefresh: () async {
        //   await Future.delayed(
        //     Duration(milliseconds: 1000),
        //   );
        //   print('refreshing');
        // },
        builder: (
          BuildContext context,
          Widget child,
          IndicatorController controller,
        ) {
          return AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, _) {
              return Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  if (!controller.isIdle)
                    Positioned(
                      top: 25.0 * controller.value,
                      child: SpinKitFadingCircle(
                        color: Theme.of(context).dividerColor,
                        size: 38.0,
                      ),
                    ),
                  Transform.translate(
                    offset: Offset(0, 80.0 * controller.value),
                    child: child,
                  ),
                ],
              );
            },
          );
        },
        child: widget.child,
      ),
    );
  }

  void _blocListener(BuildContext context, CollectiveState state) {
    if (state is CollectivePopulated &&
        refreshCompleter?.isCompleted == false) {
      refreshCompleter?.complete();
      refreshCompleter = Completer();
    }
    if (state is CollectiveError) {
      refreshCompleter?.completeError('Error during fetching');
    }
  }
}
