import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';

class CollectiveFeedRefresh extends StatefulWidget {
  CollectiveFeedRefresh({
    Key key,
   @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _CollectiveFeedRefreshState createState() => _CollectiveFeedRefreshState();
}

class _CollectiveFeedRefreshState extends State<CollectiveFeedRefresh> {
  final Completer<void> refreshCompleter = Completer<void>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CollectiveBloc, CollectiveState>(
      listener: _blocListener,
      child: CustomRefreshIndicator(
        offsetToArmed: 70,
        onRefresh: () async {
          await context.repository<NotificationsHandler>().fetchNotifications();
          await context.bloc<CollectiveBloc>().add(RefreshCollective());

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
                      top: 25 * controller.value,
                      child: SpinKitFadingCircle(
                        color: Theme.of(context).dividerColor,
                        size: 38.0,
                      ),
                    ),
                  Transform.translate(
                    offset: Offset(0, 80 * controller.value),
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
    }
    if (state is CollectiveError) {
      refreshCompleter?.completeError('Error during fetching');
    }
  }
}
