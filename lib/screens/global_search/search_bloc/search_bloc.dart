import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this.searchRepo);

  final SearchRepo searchRepo;
  int currentPos = 0;
  String lastTimeStamp;

  @override
  SearchState get initialState => InitialSearchState();

  @override
  Stream<SearchState> transformEvents(
    Stream<SearchEvent> events,
    Stream<SearchState> Function(SearchEvent p1) next,
  ) {
    final nonDebounceStream = events.where((event) => event is! SearchingEvent);
    final debounceStream = events
        .where((event) => event is SearchingEvent)
        .debounceTime(const Duration(milliseconds: 600));
    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), next);
  }

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchingEvent) {
      yield* _mapSearchingEventToState(event);
    }
    if (event is FetchMoreSearchResEvent) {
      yield* _mapFetchMoreEventToState(event);
    }
  }

  Stream<SearchState> _mapSearchingEventToState(SearchingEvent event) async* {
    yield LoadingSearchState();
    if (event.query != null && event.query.isNotEmpty) {
      try {
        final result = await _getUsers(event.query, null, null, event.username);
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
    yield LoadingSearchState();
    final event = incomingEvent as SearchingEvent;
    if (event.query != null && event.query.isNotEmpty) {
      try {
        currentPos += 50;
        final result = await _getUsers(
            event.query, currentPos, lastTimeStamp, event.username);

        if (result.results.isNotEmpty) {
          yield LoadedSearchState(result.results);
        } else {
          yield EmptySearchState();
        }
      } catch (error, stack) {
        logger.logException(error, stack);
        yield ErrorSearchState("Error searching");
      }
    }
    yield ErrorSearchState("Please enter a search term");
  }

  Future<QueryResults<UserProfile>> _getUsers(String query,
      [int pos, String time, bool username = true]) async {
    final result = await searchRepo.searchMembers(query,
        paginationPosition: pos, lastTimeStamp: time, username: username);
    lastTimeStamp = result.lastTimestamp;
    return result;
  }
}
