import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:meta/meta.dart';

part 'channel_filtering_event.dart';
part 'channel_filtering_state.dart';

class ChannelFilteringBloc
    extends Bloc<ChannelFilteringEvent, ChannelFilteringState> {
  ChannelFilteringBloc(this.searchRepository);

  final SearchRepo searchRepository;

  @override
  ChannelFilteringState get initialState => ChannelsLoadingState();

  @override
  Stream<ChannelFilteringState> mapEventToState(
    ChannelFilteringEvent event,
  ) async* {
    if (event is FilterQueryUpdated) {
      yield* _mapFilterUpdatedToState(event);
    }
    if (event is FilterSelected) {
      yield* _mapFilterSelectedToState(event);
      //
    }
    if (event is FilterReset) {
      //
    }
  }

  Stream<ChannelFilteringState> _mapFilterUpdatedToState(
      FilterQueryUpdated event) async* {
    try {
      yield ChannelsLoadingState();
      final result = await searchRepository.searchChannel(event.term);
      print(result);
      yield ChannelsPopulatedState(result.results, null);
    } catch (e, s) {
      yield ChannelsErrorState();
    }
  }

  Stream<ChannelFilteringState> _mapFilterSelectedToState(
      FilterSelected event) async* {
    //TODO(dominik): pass the info to the CollectiveBloc to fetch new expressions according to the filter
  }

  //await
}
