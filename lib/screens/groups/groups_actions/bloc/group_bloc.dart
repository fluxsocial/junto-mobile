import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/user_data/user_data_provider.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupBlocEvent, GroupBlocState> {
  GroupBloc(this.groupRepo, this.userDataProvider);
  final GroupRepo groupRepo;
final UserDataProvider userDataProvider;

  @override
  GroupBlocState get initialState => GroupBlocInitial();

  @override
  Stream<GroupBlocState> mapEventToState(
    GroupBlocEvent event,
  ) async* {
    if (event is FetchPacks) {
      _mapFetchPacksToState(event);
    }
    if (event is FetchPacksMembers) {}
  }

  Stream<GroupBlocState> _mapFetchPacksToState(FetchPacks event) async* {
    try {
      yield GroupLoading();
      final groups = await groupRepo.getUserGroups(event.userAddress);
      yield GroupLoaded(groups);
    } on JuntoException catch (error) {
      yield GroupError(error.message);
    } catch (e, s) {
      print(e);
      print(s.toString());
      yield GroupError();
    }
  }
}
