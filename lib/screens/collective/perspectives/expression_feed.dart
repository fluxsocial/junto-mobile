import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/appbar_wrapper.dart';

import 'collective_error_label.dart';
import 'collective_populated_list.dart';
import 'expression_progress_indicator.dart';
import 'expression_scroll_refresh.dart';

enum ExpressionFeedLayout { single, two }

/// Homepage feed containing a List of expression for the given perspective.
/// The following parameters must be supplied:
///  - [collectiveController]
class ExpressionFeed extends StatefulWidget {
  const ExpressionFeed({
    Key key,
    @required this.collectiveController,
  })  : assert(collectiveController != null),
        super(key: key);
  final ScrollController collectiveController;

  @override
  _ExpressionFeedState createState() => _ExpressionFeedState();
}

class _ExpressionFeedState extends State<ExpressionFeed> {
  ScrollController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = widget.collectiveController;
    _controller.addListener(_scrollListener);
  }

  @override
  void didUpdateWidget(ExpressionFeed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.collectiveController != widget.collectiveController) {
      _controller.removeListener(_scrollListener);
      _controller = widget.collectiveController;
      _controller.addListener(_scrollListener);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_scrollListener);
  }

  void _scrollListener() {
    if (_controller.hasClients) {
      final ScrollDirection direction =
          _controller.position.userScrollDirection;
      final double pixels = _controller.position.pixels;
      final double maxExtent = _controller.position.maxScrollExtent;
      double percent = (pixels / maxExtent) * 100;
      if (percent.roundToDouble() == 60 &&
          direction == ScrollDirection.reverse) {
        context.bloc<CollectiveBloc>().add(FetchMoreCollective());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpressionScrollRefresh(
      child: BlocBuilder<CollectiveBloc, CollectiveState>(
        builder: (BuildContext context, CollectiveState state) {
          if (state is CollectiveError) {
            return CollectiveErrorLabel();
          }
          return CustomScrollView(
            controller: widget.collectiveController,
            slivers: <Widget>[
              AppBarWrapper(
                title: state is CollectivePopulated ? state.name : 'JUNTO',
              ),
              if (state is CollectivePopulated) CollectivePopulatedList(state),
              if (state is CollectivePopulated && state.loadingMore == true)
                const ExpressionProgressIndicator(),
              if (state is CollectiveLoading)
                const ExpressionProgressIndicator(),
            ],
          );
        },
      ),
    );
  }
}
