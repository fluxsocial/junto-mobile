part of 'group_bloc.dart';

abstract class GroupBlocEvent {
  const GroupBlocEvent();
}

class FetchMyPack extends GroupBlocEvent {}

class RefreshPack extends GroupBlocEvent {}
