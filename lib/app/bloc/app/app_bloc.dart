import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppBlocEvent, AppBlocState> {
  AppBloc(this.repo) : super(AppLoadingState());

  final AppRepo repo;

  @override
  Stream<AppBlocState> mapEventToState(AppBlocEvent event) async* {
    if (event is CheckServerVersion) {
      yield* _mapEventToState(event);
    }
  }

  Stream<AppBlocState> _mapEventToState(CheckServerVersion event) async* {
    yield AppLoadingState();
    try {
      final validVersion = await repo.isValidVersion();
      if (validVersion) {
        print('Showing SupportedVersion');
        yield SupportedVersion();
      } else {
        print('Showing UnsupportedState');
        yield UnsupportedState();
      }
    } catch (e) {
      print('App Bloc Error $e');
      yield UnsupportedState();
    }
  }
}
