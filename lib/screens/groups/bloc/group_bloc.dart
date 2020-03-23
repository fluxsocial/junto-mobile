import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupBlocEvent, GroupBlocState> {
  GroupBloc(this.groupRepo, this.userDataProvider, this.notificationRepo);

  final GroupRepo groupRepo;
  final NotificationRepo notificationRepo;
  final UserDataProvider userDataProvider;

  @override
  GroupBlocState get initialState => GroupBlocInitial();

  @override
  Stream<GroupBlocState> mapEventToState(
    GroupBlocEvent event,
  ) async* {
    if (event is FetchMyPack) {
      yield* _mapFetchPacksToState(event);
    }
  }

  Stream<GroupBlocState> _mapFetchPacksToState(FetchMyPack event) async* {
    final String uid = userDataProvider.userProfile.user.address;
    final NotificationQuery params = NotificationQuery(
      connectionRequests: false,
      groupJoinRequests: true,
      paginationPosition: 0,
    );
    try {
      yield GroupLoading();
      final groups = await groupRepo.getUserGroups(uid);
      final users = await notificationRepo.getNotifications(params);
      final List<Group> ownedGroups = groups.owned;
      final List<Group> associatedGroups = groups.associated;

      final List<Group> userPacks =
          ListDistinct<Group>(ownedGroups, associatedGroups)
              .where((Group group) => group.groupType == 'Pack')
              .toList();
      yield GroupLoaded(userPacks, users);
    } on JuntoException catch (error) {
      yield GroupError(error.message);
    } catch (e, s) {
      print(e);
      print(s.toString());
      yield GroupError();
    }
  }

  List<T> ListDistinct<T>(List<T> listOne, List<T> listTwo) {
    final List<T> _newList = <T>[];
    _newList.addAll(listOne);
    for (final T item in listTwo) {
      if (_newList.contains(item)) {
        _newList.remove(item);
      } else {
        _newList.add(item);
      }
    }
    return _newList;
  }
}
