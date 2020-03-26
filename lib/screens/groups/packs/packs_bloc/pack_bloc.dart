import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:meta/meta.dart';

part 'pack_event.dart';
part 'pack_state.dart';

class PackBloc extends Bloc<PackEvent, PackState> {
  PackBloc(this.expressionRepo, this.groupRepo, this.groupAddress);

  final ExpressionRepo expressionRepo;
  final GroupRepo groupRepo;
  final String groupAddress;
  String lastTimestamp;

  Map<String, String> _params;
  int currentPos = 0;
  int membersPos = 0;
  String lastMemberTimeStamp;

  @override
  PackState get initialState => PackInitial();

  @override
  Stream<PackState> mapEventToState(
    PackEvent event,
  ) async* {
    if (event is FetchPacks) {
      yield* _mapFetchPacksToState(event);
    }
    if (event is FetchMorePacks) {
      yield* _mapFetchMorePacksToState(event);
    }
    if (event is FetchMorePacksMembers) {
      yield* _mapFetchMoreMembersToState(event);
    }
  }

  Stream<PackState> _mapFetchPacksToState(FetchPacks event) async* {
    _params = <String, String>{
      'context': groupAddress,
      'context_type': 'Group',
      'pagination_position': currentPos.toString(),
    };
    try {
      yield PacksLoading();
      final _results = await _fetchExpressionAndMembers();
      QueryResults<ExpressionResponse> publicQueryResults = _results[0];
      QueryResults<ExpressionResponse> privateQueryResults = _results[1];
      List<Users> members = _results[2];
      yield PacksLoaded(publicQueryResults, privateQueryResults, members);
    } on JuntoException catch (error) {
      yield PacksError(error.message);
    } catch (e, s) {
      print(e);
      print(s.toString());
      yield PacksError();
    }
  }

  Stream<PackState> _mapFetchMorePacksToState(FetchMorePacks event) async* {
    currentPos = currentPos + 50;
    _params['pagination_position'] = '$currentPos';
    _params['last_timestamp'] = lastTimestamp;

    try {
      if (_params != null && state is PacksLoaded) {
        final PacksLoaded currentResults = state as PacksLoaded;
        yield PacksLoaded(
          currentResults.publicExpressions,
          currentResults.privateExpressions,
          currentResults.groupMemebers,
        );

        final _results = await _fetchExpressionAndMembers();
        QueryResults<ExpressionResponse> publicQueryResults = _results[0];
        QueryResults<ExpressionResponse> privateQueryResults = _results[1];
        List<Users> members = _results[2];

        if (publicQueryResults.results.length > 1) {
          currentResults.publicExpressions.results
              .addAll(publicQueryResults.results);
        }
        if (privateQueryResults.results.length > 1) {
          currentResults.privateExpressions.results
              .addAll(privateQueryResults.results);
        }

        yield PacksLoaded(
          currentResults.publicExpressions,
          currentResults.privateExpressions,
          members,
        );
      }
    } on JuntoException catch (error) {
      yield PacksError(error.message);
    } catch (e, s) {
      logger.logException(e, s);
      yield PacksError();
    }
  }

  Stream<PackState> _mapFetchMoreMembersToState(event) async* {
    try {
      final currentState = state as PacksLoaded;
      final publicExpressions = currentState.publicExpressions;
      final privateExpressions = currentState.privateExpressions;
      final currentMembers = currentState.groupMemebers;
      yield PacksLoaded(publicExpressions, privateExpressions, currentMembers);

      membersPos += 50;
      final ExpressionQueryParams _params = ExpressionQueryParams(
        paginationPosition: '$membersPos',
        lastTimestamp: lastMemberTimeStamp,
      );
      final _updatedMembers = await _getMembers(groupAddress, _params);
      if (_updatedMembers.results.length > 1) {
        currentMembers.addAll(_updatedMembers.results);
        yield PacksLoaded(
          publicExpressions,
          privateExpressions,
          currentMembers,
        );
      }
    } catch (error, stack) {
      logger.logException(error, stack);
      yield PacksError();
    }
  }

  Future<List> _fetchExpressionAndMembers() async {
    final QueryResults<ExpressionResponse> results =
        await expressionRepo.getPackExpressions(
      _params,
    );
    final members = await _getMembers(
        groupAddress, ExpressionQueryParams(paginationPosition: '0'));

    List<ExpressionResponse> _public = results.results
        .where((element) => element.privacy == 'Public')
        .toList();
    List<ExpressionResponse> _private = results.results
        .where((element) => element.privacy == 'Private')
        .toList();

    lastTimestamp = results.lastTimestamp;

    final publicQueryResults = QueryResults(
      results: _public,
      lastTimestamp: results.lastTimestamp,
    );
    final privateQueryResults = QueryResults(
      results: _private,
      lastTimestamp: results.lastTimestamp,
    );
    return [publicQueryResults, privateQueryResults, members.results];
  }

  Future<QueryResults<Users>> _getMembers(
      final String groupAddress, ExpressionQueryParams params) async {
    final result = await groupRepo.getGroupMembers(groupAddress, params);
    lastMemberTimeStamp = result.lastTimestamp;
    return result;
  }
}
