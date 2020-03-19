part of 'group_bloc.dart';

abstract class GroupBlocEvent {
  const GroupBlocEvent();
}

class FetchPacks extends GroupBlocEvent {
  FetchPacks(this.userAddress);
  final String userAddress;
}

class FetchPacksMembers extends GroupBlocEvent {}
