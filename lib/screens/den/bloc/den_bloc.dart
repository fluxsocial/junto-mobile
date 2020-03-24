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

  DenBloc(this.userRepo, this.userData);

  int currentPage = 0;
  String currentTimeStamp;

  @override
  DenState get initialState => DenInitial();

  @override
  Stream<DenState> mapEventToState(DenEvent event) async* {
    if (event is LoadDen) {
      yield* _fetchUserDenExpressions(event);
    }
    if (event is LoadMoreDen) {
      yield* _fetchMoreUserDenExpressions(event);
    }
  }

  Stream<DenState> _fetchUserDenExpressions(event) async* {
    try {
      yield DenLoadingState();
      final userExpressions = await fetchExpressions();
      currentTimeStamp = userExpressions.lastTimestamp;
      print(currentTimeStamp);
      if (userExpressions.results.isEmpty) {
        yield DenEmptyState();
      } else {
        yield DenLoadedState(userExpressions.results);
      }
    } on JuntoException catch (e) {
      yield DenErrorState(e.message);
    }
  }

  Stream<DenState> _fetchMoreUserDenExpressions(event) async* {
    try {
      if (state is DenLoadedState) {
        final DenLoadedState data = state;
        yield DenLoadedState(data.expressions);
        currentPage = currentPage + 50;
        final userExpressions = await fetchExpressions();
        if (userExpressions.results.length > 1) {
          data.expressions.addAll(userExpressions.results);
        }
        yield DenLoadedState(data.expressions);
      }
    } on JuntoException catch (e) {
      yield DenErrorState(e.message);
    }
  }

  Future<QueryResults<ExpressionResponse>> fetchExpressions() async {
    final userAddress = userData.userAddress;
    final result = await userRepo.getUsersExpressions(
      userAddress,
      currentPage,
      currentTimeStamp,
    );
    return result;
  }
}
