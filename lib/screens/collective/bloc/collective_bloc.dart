import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:meta/meta.dart';

part 'collective_event.dart';
part 'collective_state.dart';

class CollectiveBloc extends Bloc<CollectiveEvent, CollectiveState> {
  CollectiveBloc(this.expressionRepository, this.onUnauthorized);

  final ExpressionRepo expressionRepository;
  final VoidCallback onUnauthorized;
  Map<String, String> _params;

  @override
  CollectiveState get initialState => CollectiveInitial();

  @override
  Stream<CollectiveState> mapEventToState(
    CollectiveEvent event,
  ) async* {
    if (event is FetchCollective) {
      yield* _mapFetchCollectiveToState(event);
    }
    if (event is FetchMoreCollective) {
      //TODO: implement fetching more expressions
    }
    if (event is RefreshCollective) {
      yield* _mapRefreshToState(event);
    }
  }

  Stream<CollectiveState> _mapRefreshToState(RefreshCollective event) async* {
    yield CollectiveLoading();

    final QueryResults<ExpressionResponse> expressions =
        await expressionRepository.getCollectiveExpressions(_params);
    debugPrint(expressions.results.take(5).toString());

    yield CollectivePopulated(expressions.results);
  }

  Stream<CollectiveState> _mapFetchCollectiveToState(
      FetchCollective event) async* {
    try {
      yield CollectiveLoading();
      final data = event.param;

      _params = <String, String>{
        'context_type': 'Collective',
        // 'context': event.contextString,
        'pagination_position': data.paginationPosition,
        if (data.channels?.isNotEmpty == true)
          'channels[0]': data.channels[0]
      };
      // _params = Map<String, String>.from(data);
      final expressions =
          await expressionRepository.getCollectiveExpressions(_params);
      print('Fetched ${expressions.results.length} expressions from API');

      yield CollectivePopulated(expressions.results);
    } on JuntoException catch (e, s) {
      print(
          'Error during fetching expression ${e.message}: ${e.errorCode}: $s');
      if (e.errorCode == 401) {
        print('Unauthorized, popping to the welcome screen');
        onUnauthorized();
      }
    } catch (e, s) {
      print(e);
      print(s.toString());
      yield CollectiveError();
    }
  }
}
