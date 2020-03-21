import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'collective_event.dart';
part 'collective_state.dart';

class CollectiveBloc extends Bloc<CollectiveEvent, CollectiveState> {
  CollectiveBloc(this.expressionRepository, this.onUnauthorized);

  final ExpressionRepo expressionRepository;
  final VoidCallback onUnauthorized;
  Map<String, String> _params;
  ExpressionQueryParams _previousParameters;
  int _currentPage = 0;
  String _lastTimeStamp;

  @override
  Stream<CollectiveState> transformEvents(
    Stream<CollectiveEvent> events,
    Stream<CollectiveState> Function(CollectiveEvent event) next,
  ) {
    final nonDebounceStream = events.where((event) => event is FetchCollective);
    final debounceStream = events
        .where((event) =>
            event is RefreshCollective || event is FetchMoreCollective)
        .debounceTime(const Duration(milliseconds: 1000));
    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), next);
  }

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
      yield* _mapFetchMoreCollectiveToState(event);
    }
    if (event is RefreshCollective) {
      yield* _mapRefreshToState(event);
    }
  }

  Stream<CollectiveState> _mapRefreshToState(RefreshCollective event) async* {
    try {
      if (state is CollectivePopulated) {
        // we are not emitting LoadingState here as we are using RefreshIndicator to show loading state

        _updateParams(true, _previousParameters);
        final expressions = await _fetchExpressions();

        yield CollectivePopulated(
          expressions.results,
          false,
          (state as CollectivePopulated).name,
        );
      }
    } on JuntoException catch (e, s) {
      handleJuntoException(e, s);
    } catch (e, s) {
      print(e);
      print(s.toString());
      yield CollectiveError();
    }
  }

  Stream<CollectiveState> _mapFetchCollectiveToState(
      FetchCollective event) async* {
    try {
      final name = getCurrentName(event);
      yield CollectiveLoading();

      _updateParams(true, event.param);
      final expressions = await _fetchExpressions();

      yield CollectivePopulated(expressions.results, false, name);
    } on JuntoException catch (e, s) {
      handleJuntoException(e, s);
    } catch (e, s) {
      print(e);
      print(s.toString());
      yield CollectiveError();
    }
  }

  String getCurrentName(FetchCollective event) {
    String name = event.param.name;
    if (name == null && state is CollectivePopulated) {
      name = (state as CollectivePopulated)?.name;
    }
    return name;
  }

  Stream<CollectiveState> _mapFetchMoreCollectiveToState(
    FetchMoreCollective event,
  ) async* {
    try {
      if (_params != null && state is CollectivePopulated) {
        final currentState = state as CollectivePopulated;
        yield CollectivePopulated(
          currentState.results,
          true,
          currentState.name,
        );

        _updateParams(false, null);
        final expressions = await _fetchExpressions();

        final currentResult = currentState.results;
        if (currentState.results.length <= 1) {
          currentResult.addAll(expressions.results);
        }
        yield CollectivePopulated(
          currentResult,
          false,
          currentState.name,
        );
      }
    } on JuntoException catch (e, s) {
      handleJuntoException(e, s);
    } catch (e, s) {
      print(e);
      print(s.toString());
      yield CollectiveError();
    }
  }

  Future<QueryResults<ExpressionResponse>> _fetchExpressions() async {
    final expressions =
        await expressionRepository.getCollectiveExpressions(_params);
    print(
        'Fetched ${expressions.results.length} expressions from API, last_timestamp: ${expressions.lastTimestamp}');
    _lastTimeStamp = expressions.lastTimestamp;
    return expressions;
  }

  void _updateParams(bool clean, ExpressionQueryParams currentParameters) {
    if (clean) {
      //refreshing or fetching from zero
      final currentContextType = currentParameters.contextType ??
          _previousParameters?.contextType ??
          ExpressionContextType.Collective;

      final currentChannels = currentParameters.channels ?? [];

      final currentContext =
          currentParameters.context ?? _previousParameters?.context;

      _lastTimeStamp = null;
      _currentPage = 0;
      _previousParameters = ExpressionQueryParams(
        contextType: currentContextType,
        dos: currentParameters.dos,
        paginationPosition: currentParameters.paginationPosition,
        context: currentContext,
        channels: currentChannels,
      );

      _params = <String, String>{
        'context_type': ExpressionContextTypeEnumMap[currentContextType],
        'pagination_position': '$_currentPage',
        if (currentChannels.isNotEmpty == true)
          'channels[0]': currentChannels[0],
        if (currentContext != null) 'context': currentContext,
      };
    } else {
      // scrolling down
      _params['last_timestamp'] = _lastTimeStamp;
      _params['pagination_position'] =
          (_currentPage = _currentPage + 50).toString();
    }
  }

  void handleJuntoException(JuntoException e, StackTrace s) {
    print('Error during fetching expression ${e.message}: ${e.errorCode}: $s');
    if (e.errorCode == 401) {
      print('Unauthorized, popping to the welcome screen');
      onUnauthorized();
    }
  }

  static const ExpressionContextTypeEnumMap = {
    ExpressionContextType.Dos: 'Dos',
    ExpressionContextType.FollowPerspective: 'FollowPerspective',
    ExpressionContextType.Collective: 'Collective',
    ExpressionContextType.Group: 'Group',
    ExpressionContextType.ConnectPerspective: 'ConnectPerspective',
  };
}
