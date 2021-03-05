import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/filters/bloc/channel_filtering_bloc.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';

void onPerspectivesChanged(PerspectiveModel perspective, BuildContext context) {
  final bloc = context.bloc<CollectiveBloc>();
  final channels =
      context.bloc<ChannelFilteringBloc>().state.selectedChannel != null
          ? context
              .bloc<ChannelFilteringBloc>()
              .state
              .selectedChannel
              .map((e) => e.name)
              .toList()
          : <String>[];

  if (perspective.name == 'Collective' && perspective.address == null) {
    bloc.add(
      FetchCollective(
        ExpressionQueryParams(
          contextType: ExpressionContextType.Collective,
          name: perspective.name,
          channels: channels,
        ),
      ),
    );
  } else if (perspective.name == 'Connections') {
    bloc.add(
      FetchCollective(
        ExpressionQueryParams(
          contextType: ExpressionContextType.ConnectPerspective,
          dos: '0',
          context: perspective.address,
          name: perspective.name,
          channels: channels,
        ),
      ),
    );
  } else {
    bloc.add(
      FetchCollective(
        ExpressionQueryParams(
          contextType: ExpressionContextType.FollowPerspective,
          dos: null,
          context: perspective.address,
          name: perspective.name.contains("'s Follow Perspective")
              ? 'Subscriptions'
              : perspective.name,
          channels: channels,
        ),
      ),
    );
  }
  // set current perspective
  bloc.setCurrentPerspective(perspective);
  context.bloc<ChannelFilteringBloc>().add(FilterClear());
}
