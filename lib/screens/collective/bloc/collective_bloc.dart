import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:meta/meta.dart';

part 'collective_event.dart';
part 'collective_state.dart';

class CollectiveBloc extends Bloc<CollectiveEvent, CollectiveState> {
  CollectiveBloc(this.expressionRepository);

  final ExpressionRepo expressionRepository;

  @override
  CollectiveState get initialState => CollectiveInitial();

  @override
  Stream<CollectiveState> mapEventToState(
    CollectiveEvent event,
  ) async* {
    if (event is CollectiveFetch) {
      // fetch
      yield* _mapFetchToState(event);
    }
    if (event is CollectiveRefresh) {
      // refresh
    }
  }

  Stream<CollectiveState> _mapFetchToState(CollectiveFetch event) async* {
    yield CollectiveLoading();
    Map<String, dynamic> _params;
    // TODO(dominik): I don't quite understand all these parameters
    if (event.contextType == 'Dos' && event.dos != -1) {
      _params = <String, String>{
        'context_type': event.contextType,
        'pagination_position': event.paginationPos.toString(),
        'dos': event.dos.toString(),
      };
    } else if (event.contextType == 'ConnectPerspective') {
      _params = <String, String>{
        'context_type': event.contextType,
        // 'context': _userProfile.connectionPerspective.address,
        'pagination_position': event.paginationPos.toString(),
        // if (_channels.isNotEmpty) 'channels[0]': _channels[0]
      };
    } else {
      _params = <String, String>{
        'context_type': event.contextType,
        // 'context': event.contextString,
        'pagination_position': event.paginationPos.toString(),
        // if (_channels.isNotEmpty) 'channels[0]': _channels[0]
      };
    }

    final QueryResults<ExpressionResponse> expressions =
        await expressionRepository.getCollectiveExpressions(_params);

    yield CollectivePopulated(expressions.results);
  }
}
