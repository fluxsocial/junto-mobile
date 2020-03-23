import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
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

  Map<String, String> _params;

  @override
  PackState get initialState => PackInitial();

  @override
  Stream<PackState> mapEventToState(
    PackEvent event,
  ) async* {
    if (event is FetchPacks) {
      yield* _mapFetchPacksToState(event);
    }
  }

  Stream<PackState> _mapFetchPacksToState(FetchPacks event) async* {
    _params = <String, String>{
      'context': groupAddress,
      'context_type': 'Group',
      'pagination_position': '0',
    };
    try {
      yield PacksLoading();
      final QueryResults<ExpressionResponse> results =
          await expressionRepo.getPackExpressions(
        _params,
      );
      final memebers = await groupRepo.getGroupMembers(groupAddress);
      List<ExpressionResponse> _public = results.results
          .where((element) => element.privacy == 'Public')
          .toList();
      List<ExpressionResponse> _private = results.results
          .where((element) => element.privacy == 'Private')
          .toList();

      final publicQueryResults = QueryResults(
        results: _public,
        lastTimestamp: results.lastTimestamp,
      );
      final privateQueryResults = QueryResults(
        results: _private,
        lastTimestamp: results.lastTimestamp,
      );

      yield PacksLoaded(publicQueryResults, privateQueryResults, memebers);
    } on JuntoException catch (error) {
      yield PacksError(error.message);
    } catch (e, s) {
      logger.logException(e, s);
      yield PacksError();
    }
  }
}
