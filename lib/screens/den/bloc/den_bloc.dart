import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:meta/meta.dart';

part 'den_event.dart';
part 'den_state.dart';

class DenBloc extends Bloc<DenEvent, DenState> {
  final UserRepo userRepo;
  final UserDataProvider userData;
  final ExpressionRepo expressionRepo;

  DenBloc(this.userRepo, this.userData, this.expressionRepo)
      : super(DenInitial());

  String userAddress;
  int currentPage = 0;
  String currentTimeStamp;
  Map<String, bool> _params;

  @override
  Stream<DenState> mapEventToState(DenEvent event) async* {
    // root expression events
    if (event is LoadDen) {
      yield* _fetchUserDenExpressions(event);
    }
    if (event is LoadMoreDen) {
      yield* _fetchMoreUserDenExpressions(event);
    }
    if (event is RefreshDen) {
      yield* _refreshUserDenExpressions(event);
    }

    if (event is DeleteDenExpression) {
      yield* _deleteUserExpression(event);
    }
  }

  Stream<DenState> _fetchUserDenExpressions(dynamic event) async* {
    userAddress = event.userAddress;
    _updateParams(event);
    try {
      yield DenLoadingState();
      final userInfo = await userRepo.getUser(userData.userAddress);
      userData.updateUser(userInfo);
      final userExpressions = await fetchExpressions(event.params);
      currentTimeStamp = userExpressions.lastTimestamp;
      if (userExpressions.results.isEmpty) {
        yield DenEmptyState();
      } else {
        yield DenLoadedState(userExpressions.results);
      }
    } on JuntoException catch (e) {
      yield DenErrorState(e.message);
    }
  }

  void _updateParams(LoadDen event) {
    _params = event.params;
  }

  Stream<DenState> _deleteUserExpression(dynamic event) async* {
    try {
      if (state is DenLoadedState) {
        final DenLoadedState data = state;
        await expressionRepo.deleteExpression(event.address);
        final updatedList = data.expressions;
        updatedList.removeWhere((element) => element.address == event.address);
        yield DenLoadedState(updatedList);
      }
    } on JuntoException catch (e) {
      yield DenErrorState(e.message);
    }
  }

  Stream<DenState> _fetchMoreUserDenExpressions(
    dynamic event,
  ) async* {
    try {
      if (state is DenLoadedState) {
        final DenLoadedState data = state;
        yield DenLoadedState(data.expressions);
        currentPage = currentPage + 50;
        final userExpressions = await fetchExpressions(_params);
        if (userExpressions.results.length > 1) {
          data.expressions.addAll(userExpressions.results);
        }
        yield DenLoadedState(data.expressions);
      }
    } on JuntoException catch (e) {
      yield DenErrorState(e.message);
    }
  }

  Stream<DenState> _refreshUserDenExpressions(
    dynamic event,
  ) async* {
    try {
      yield DenLoadingState();
      final userExpressions = await fetchExpressions(_params);
      currentTimeStamp = userExpressions.lastTimestamp;
      if (userExpressions.results.isEmpty) {
        yield DenEmptyState();
      } else {
        yield DenLoadedState(userExpressions.results);
      }
    } on JuntoException catch (e) {
      yield DenErrorState(e.message);
    }
  }

  Future<QueryResults<ExpressionResponse>> fetchExpressions(
      Map<String, bool> params) async {
    final result = await userRepo.getUsersExpressions(
      userAddress,
      currentPage,
      currentTimeStamp,
      params['rootExpressions'],
      params['subExpressions'],
      params['communityFeedback'],
    );
    currentTimeStamp = result.lastTimestamp;

    return result;
  }
}
