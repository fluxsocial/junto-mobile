import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppBlocEvent, AppBlocState> {
  AppBloc(this.repo) : super(AppBlocInitial());

  final AppRepo repo;

  @override
  Stream<AppBlocState> mapEventToState(AppBlocEvent event) async* {
    if (event is CheckServerVersion) {
      yield* _mapEventToState(event);
    }
  }

  Stream<AppBlocState> _mapEventToState(CheckServerVersion event) async* {
    if (await repo.isValidVersion()) {
      yield SupportedVersion();
    } else {
      yield UnsupportedState();
    }
  }
}
