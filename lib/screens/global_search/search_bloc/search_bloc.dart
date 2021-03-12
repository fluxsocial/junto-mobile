import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this.searchRepo) : super(InitialSearchState());

  final SearchRepo searchRepo;
  int currentPos = 0;
  String lastTimeStamp;

  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(
    Stream<SearchEvent> events,
    TransitionFunction<SearchEvent, SearchState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) => event is! SearchEvent);
    final debounceStream = events
        .where((event) => event is SearchEvent)
        .debounceTime(const Duration(milliseconds: 600));
    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  }

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchingEvent) {
      yield* _mapSearchingEventToState(event);
    }

    if (event is SearchingChannelEvent) {
      yield* _mapSearchingChannelEventToState(event);
    }

    if (event is FetchMoreSearchResEvent) {
      yield* _mapFetchMoreEventToState(event);
    }
  }

  Stream<SearchState> _mapSearchingChannelEventToState(
      SearchingChannelEvent event) async* {
    yield LoadingSearchChannelState();
    if (event.query != null && event.query.isNotEmpty) {
      try {
        final result = await _getChannels(event.query);

        if (result.results.isNotEmpty) {
          yield LoadedSearchChannelState(result.results);
        } else {
          yield EmptySearchChannelState();
        }
      } catch (error, stack) {
        logger.logException(error, stack);
        yield ErrorSearchChannelState("Error searching");
      }
    } else {
      yield EmptySearchChannelState();
    }
  }

  Stream<SearchState> _mapSearchingEventToState(SearchingEvent event) async* {
    yield LoadingSearchState();
    if (event.query != null && event.query.isNotEmpty) {
      try {
        currentPos = 0;
        final result = await _getUsers(event.query, null, null, event.username);

        lastTimeStamp = result.lastTimestamp;

        if (result.results.isNotEmpty) {
          yield LoadedSearchState(result.results);
        } else {
          yield EmptySearchState();
        }
      } catch (error, stack) {
        logger.logException(error, stack);
        yield ErrorSearchState("Error searching");
      }
    } else {
      yield EmptySearchState();
    }
  }

  Stream<SearchState> _mapFetchMoreEventToState(
      FetchMoreSearchResEvent incomingEvent) async* {
    final results = state as LoadedSearchState;
    final event = incomingEvent;
    if (event.query != null &&
        event.query.isNotEmpty &&
        results.results.length % 50 == 0) {
      try {
        currentPos += 50;
        final result = await _getUsers(
            event.query, currentPos, lastTimeStamp, event.username);

        lastTimeStamp = result.lastTimestamp;

        if (result.results.isNotEmpty) {
          yield LoadedSearchState([...results.results, ...result.results]);
        }
      } catch (error, stack) {
        logger.logException(error, stack);
      }
    }
  }

  Future<QueryResults<UserProfile>> _getUsers(
    String query, [
    int pos,
    String time,
    QueryUserBy username = QueryUserBy.USERNAME,
  ]) async {
    final result = await searchRepo.searchMembers(query,
        paginationPosition: pos, lastTimeStamp: time, username: username);
    lastTimeStamp = result.lastTimestamp;
    return result;
  }

  Future<QueryResults<Channel>> _getChannels(String query,
      [int paginationPosition = 0, DateTime time]) async {
    final result = await searchRepo.searchChannel(query,
        paginationPosition: paginationPosition, lastTimeStamp: time);
    lastTimeStamp = result.lastTimestamp;
    return result;
  }

  @override
  String toString() => 'SearchBloc';
}
