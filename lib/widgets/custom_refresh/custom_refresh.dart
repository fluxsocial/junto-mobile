import 'dart:async';

import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:junto_beta_mobile/screens/den/bloc/den_bloc.dart';

class CustomRefresh extends StatefulWidget {
  CustomRefresh({
    Key key,
    this.child,
    this.refresh,
  }) : super(key: key);

  final Widget child;
  final Function refresh;

  @override
  _CustomRefreshState createState() => _CustomRefreshState();
}

class _CustomRefreshState extends State<CustomRefresh> {
  Completer<void> refreshCompleter = Completer<void>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<DenBloc, DenState>(
      listener: (context, state) {
        if ((state is DenLoadedState || state is DenEmptyState) &&
            refreshCompleter?.isCompleted == false) {
          refreshCompleter?.complete();
          refreshCompleter = Completer<void>();
        }

        if (state is DenErrorState) {
          refreshCompleter?.completeError('Error during fetching');
          refreshCompleter = Completer<void>();
        }
      },
      child: CustomRefreshIndicator(
        offsetToArmed: 70,
        onRefresh: () async {
          await widget.refresh();

          return refreshCompleter.future;
        },
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
}
