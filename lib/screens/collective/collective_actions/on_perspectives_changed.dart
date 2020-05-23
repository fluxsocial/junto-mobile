import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/filters/bloc/channel_filtering_bloc.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';

void onPerspectivesChanged(PerspectiveModel perspective, BuildContext context) {
  final bloc = context.bloc<CollectiveBloc>();

  if (perspective.name == 'JUNTO') {
    bloc.add(
      FetchCollective(
        ExpressionQueryParams(
          contextType: ExpressionContextType.Collective,
          name: perspective.name,
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
        ),
      ),
    );
  }
  context.bloc<ChannelFilteringBloc>().add(FilterClear());
}
