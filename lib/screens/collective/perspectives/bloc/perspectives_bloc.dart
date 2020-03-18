import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:junto_beta_mobile/user_data/user_data_provider.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';

part 'perspectives_event.dart';
part 'perspectives_state.dart';

class PerspectivesBloc extends Bloc<PerspectivesEvent, PerspectivesState> {
  PerspectivesBloc(this.userRepository, this.userDataProvider);

  final UserRepo userRepository;
  final UserDataProvider userDataProvider;

  @override
  PerspectivesState get initialState => PerspectivesInitial();

  @override
  Stream<PerspectivesState> mapEventToState(
    PerspectivesEvent event,
  ) async* {
    if (event is FetchPerspectives) {
      yield* _mapFetchToState(event);
    }
    if (event is RemovePerspective) {
      //
    }
    if (event is EditPerspective) {
      //
    }
  }

  Future<List<PerspectiveModel>> _fetchUserPerspectives(String address) async {
    try {
      return await userRepository.getUserPerspective(address);
    } on JuntoException catch (error) {
      debugPrint('error fethcing perspectives ${error.errorCode}');
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) => SingleActionDialog(
      //     dialogText: error.message,
      //   ),
      // );
      return null;
    }
  }

  Stream<PerspectivesState> _mapFetchToState(FetchPerspectives event) async* {
    try {
      final address = userDataProvider.userAddress;
      final persp = await _fetchUserPerspectives(address);
      if (persp != null) {
        yield PerspectivesFetched(persp);
      } else {
        yield PerspectivesError();
      }
    } catch (e) {
      yield PerspectivesError();
    }
  }
}
