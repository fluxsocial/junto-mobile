import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'channel_filtering_event.dart';
part 'channel_filtering_state.dart';

typedef OnFilterApplied = void Function(Channel);

class ChannelFilteringBloc
    extends Bloc<ChannelFilteringEvent, ChannelFilteringState> {
  ChannelFilteringBloc(this.searchRepository, this.onFilterApplied)
      : super(const ChannelsInitialState());

  final SearchRepo searchRepository;
  final OnFilterApplied onFilterApplied;

  // This debounces type events but leaves other events with normal "pace"
  @override
  Stream<Transition<ChannelFilteringEvent, ChannelFilteringState>>
      transformEvents(
    Stream<ChannelFilteringEvent> events,
    TransitionFunction<ChannelFilteringEvent, ChannelFilteringState>
        transitionFn,
  ) {
    final nonDebounceStream =
        events.where((event) => event is! FilterQueryUpdated);
    final debounceStream = events
        .where((event) => event is FilterQueryUpdated)
        .debounceTime(const Duration(milliseconds: 600));
    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  }

  @override
  Stream<ChannelFilteringState> mapEventToState(
    ChannelFilteringEvent event,
  ) async* {
    if (event is FilterQueryUpdated) {
      yield* _mapFilterUpdatedToState(event);
    }
    if (event is FilterSelected) {
      yield* _mapFilterSelectedToState(event);
    }
    if (event is FilterReset) {
      yield* _mapFilterResetToState(event);
    }
    if (event is FilterClear) {
      yield* _mapFilterClearToState(event);
    }
  }

  Stream<ChannelFilteringState> _mapFilterUpdatedToState(
      FilterQueryUpdated event) async* {
    try {
      if (event.term.isNotEmpty && event.term.length > 1) {
        final result = await searchRepository.searchChannel(event.term);
        logger.logDebug(
            'Channels available for query ${event.term} ${result.results.length}');
        yield ChannelsPopulatedState(result.results, state.selectedChannel);
      }
    } catch (e, s) {
      logger.logException(e, s, 'Error during updating the filter');
      yield const ChannelsErrorState();
    }
  }

  Stream<ChannelFilteringState> _mapFilterSelectedToState(
      FilterSelected event) async* {
    onFilterApplied(event.item);
    yield ChannelsPopulatedState([], event.item);
  }

  Stream<ChannelFilteringState> _mapFilterResetToState(
      FilterReset event) async* {
    onFilterApplied(null);
    yield const ChannelsPopulatedState([], null);
  }

  Stream<ChannelFilteringState> _mapFilterClearToState(
      FilterClear event) async* {
    yield const ChannelsPopulatedState([], null);
  }
}
