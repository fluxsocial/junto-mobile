part of 'pack_bloc.dart';

@immutable
abstract class PackEvent {}

class FetchPacks extends PackEvent {
  final String group;

  FetchPacks({this.group});
}

class FetchMorePacks extends PackEvent {}

class FetchPacksMembers extends PackEvent {
  FetchPacksMembers(this.groupAddress);
  final String groupAddress;
}

class FetchMorePacksMembers extends PackEvent {}
