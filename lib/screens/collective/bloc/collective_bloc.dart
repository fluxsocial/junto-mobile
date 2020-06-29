import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'collective_state.dart';

export 'collective_state.dart';

part 'collective_event.dart';

class CollectiveBloc extends Bloc<CollectiveEvent, CollectiveState> {
  CollectiveBloc(this.expressionRepository);

  final expressionsPerPage = 50;
  final ExpressionRepo expressionRepository;
  Map<String, String> _params;
  ExpressionQueryParams _previousParameters;
  int _currentPage = 0;
  PerspectiveModel _currentPerspective;

  String _lastTimeStamp;

  @override
  Stream<Transition<CollectiveEvent, CollectiveState>> transformEvents(
    Stream<CollectiveEvent> events,
    TransitionFunction<CollectiveEvent, CollectiveState> transitionFn,
  ) {
    final nonDebounceStream = events.where(
        (event) => event is FetchCollective || event is DeleteCollective);
    final debounceStream = events
        .where((event) =>
            event is RefreshCollective || event is FetchMoreCollective)
        .debounceTime(const Duration(milliseconds: 1000));
    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  }

  @override
  CollectiveState get initialState => CollectiveState.initial();

  PerspectiveModel get currentPerspective => _currentPerspective;

  setCurrentPerspective(PerspectiveModel perspective) {
    _currentPerspective = perspective;
  }

  @override
  Stream<CollectiveState> mapEventToState(CollectiveEvent event) async* {
    if (event is DeleteCollective) {
      yield* _mapDeleteToState(event);
    }
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

        yield CollectiveState.populated(
          expressions.results,
          false,
          (state as CollectivePopulated).name,
          expressions.results.length == expressionsPerPage,
        );
      }
    } on JuntoException catch (e, s) {
      handleJuntoException(e, s);
    } catch (e, s) {
      logger.logException(e, s, 'Error during refreshing the collective');
      yield CollectiveState.error();
    }
  }

  Stream<CollectiveState> _mapDeleteToState(DeleteCollective event) async* {
    try {
      await expressionRepository.deleteExpression(event.address);
      final currentState = state as CollectivePopulated;
      final results = currentState.results.toList();
      results.removeWhere((element) => element.address == event.address);
      yield CollectiveState.populated(
        results,
        false,
        currentState.name,
        currentState.results.length == expressionsPerPage,
      );
    } on JuntoException catch (e, s) {
      handleJuntoException(e, s);
    } catch (e, s) {
      logger.logException(e, s, 'Error during refreshing the collective');
      yield CollectiveState.error();
    }
  }

  Stream<CollectiveState> _mapFetchCollectiveToState(
      FetchCollective event) async* {
    try {
      final name = getCurrentName(event);
      yield CollectiveState.loading();

      _updateParams(true, event.param);
      final expressions = await _fetchExpressions();

      yield CollectiveState.populated(
        expressions.results,
        false,
        name,
        expressions.results.length == expressionsPerPage,
      );
    } on JuntoException catch (e, s) {
      handleJuntoException(e, s);
    } catch (e, s) {
      logger.logException(e, s, 'Error during fetching the collective');
      yield CollectiveState.error();
    }
  }

  String getCurrentName(FetchCollective event) {
    String name = event.param.name;
    if (name == null && state is CollectivePopulated) {
      name = (state as CollectivePopulated)?.name;
    }
    return name ?? 'JUNTO';
  }

  Stream<CollectiveState> _mapFetchMoreCollectiveToState(
    FetchMoreCollective event,
  ) async* {
    try {
      if (_params != null && state is CollectivePopulated) {
        final currentState = state as CollectivePopulated;
        yield CollectiveState.populated(
          currentState.results,
          true,
          currentState.name,
          false,
        );

        _updateParams(false, null);
        final expressions = await _fetchExpressions();

        final currentResult = currentState.results;
        if (expressions.results.length > 1) {
          // The server sends the first expression as the last from the previous
          // query

          expressions.results.removeAt(0);
          currentResult.addAll(expressions.results);
          yield CollectiveState.populated(
            currentResult,
            false,
            currentState.name,
            expressions.results.length == expressionsPerPage,
          );
        } else {
          yield CollectiveState.populated(
            currentState.results,
            false,
            currentState.name,
            false,
          );
        }
      }
    } on JuntoException catch (e, s) {
      handleJuntoException(e, s);
    } catch (e, s) {
      logger.logException(e, s, 'Error during fetching more of the collective');
      yield CollectiveState.error();
    }
  }

  Future<QueryResults<ExpressionResponse>> _fetchExpressions() async {
    final expressions =
        await expressionRepository.getCollectiveExpressions(_params);
    logger.logDebug(
        'Fetched ${expressions.results.length} expressions from API, last_timestamp: ${expressions.lastTimestamp}. ');
    if (expressions.results.length > 1) {
      logger.logDebug(
          'First: ${expressions.results?.first}, Last: ${expressions.results?.last}');
    }
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
        'context_type': ExpressionQueryParams
            .ExpressionContextTypeEnumMap[currentContextType],
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
    logger.logError(
        'Error during fetching expression ${e.message}: ${e.errorCode}: $s');
    if (e.errorCode == 401) {
      logger.logError('Unauthorized, should be handled on lotus screen');
    }
  }
}
