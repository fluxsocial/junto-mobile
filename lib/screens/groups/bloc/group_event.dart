part of 'group_bloc.dart';

abstract class GroupBlocEvent {
  const GroupBlocEvent();
}

class FetchMyPack extends GroupBlocEvent {
  FetchMyPack(this.userAddress);
  final String userAddress;
}

class FetchPacksMembers extends GroupBlocEvent {}
