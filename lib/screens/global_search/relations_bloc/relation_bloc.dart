import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:rxdart/rxdart.dart';

part 'relation_event.dart';
part 'relation_state.dart';

class RelationBloc extends Bloc<RelationEvent, RelationState> {
  RelationBloc(this.userRepo) : super(InitialRelationState());

  final UserRepo userRepo;
  int currentPos = 0;
  String lastTimestamp;

  @override
  Stream<Transition<RelationEvent, RelationState>> transformEvents(
    Stream<RelationEvent> events,
    TransitionFunction<RelationEvent, RelationState> transitionFn,
  ) {
    final nonDebounceStream =
        events.where((event) => event is! SearchRelationship);
    final debounceStream = events
        .where((event) => event is SearchRelationship)
        .debounceTime(const Duration(milliseconds: 600));
    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  }

  @override
  Stream<RelationState> mapEventToState(
    RelationEvent event,
  ) async* {
    if (event is FetchRealtionship) {
      yield* _mapFetchRealtionshipEventToState(event);
    } else if (event is FetchMoreRelationship) {
      yield* _mapFetchMoreRelationshipEventToState(event);
    } else if (event is SearchRelationship) {
      yield* _mapSearchRelationshipEventToState(event);
    }
  }

  Stream<RelationState> _mapFetchRealtionshipEventToState(
      FetchRealtionship event) async* {
    yield RelationLoadingState();

    try {
      final relations = await getUserRelations();
      final _connections = relations['connections']['results'];
      final _following = relations['following']['results'];
      final _followers = relations['followers']['results'];

      yield RelationLoadedState(
        followers: _followers,
        following: _following,
        connections: _connections,
      );
    } catch (error, stack) {
      logger.logException(error, stack);
      yield RelationErrorState('Error while fetching relationships');
    }
  }

  Stream<RelationState> _mapFetchMoreRelationshipEventToState(
      FetchMoreRelationship event) async* {
    try {
      currentPos += 50;
      final relations = await getUserRelations();
      final _connections = relations['connections']['results'];
      final _following = relations['following']['results'];
      final _followers = relations['followers']['results'];

      yield RelationLoadedState(
        followers: _followers,
        following: _following,
        connections: _connections,
      );
    } catch (error, stack) {
      logger.logException(error, stack);
      yield RelationErrorState('Error while fetching relationships');
    }
  }

  Stream<RelationState> _mapSearchRelationshipEventToState(
      SearchRelationship event) async* {
    yield RelationLoadingState();

    try {
      final _query = event.query;
      final relations = await getUserRelations();
      final _connections = relations['connections']['results'];
      final _following = relations['following']['results'];
      final _followers = relations['followers']['results'];

      yield RelationLoadedState(
        followers: _followers,
        following: _following,
        connections: _connections,
      );
    } catch (error, stack) {
      logger.logException(error, stack);
      yield RelationErrorState('Error while fetching relationships');
    }
  }

  Future<dynamic> getUserRelations() async {
    final dynamic userRelations = await userRepo.userRelations();

    return userRelations;
  }
}
