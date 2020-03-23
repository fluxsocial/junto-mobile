part of 'pack_bloc.dart';

@immutable
abstract class PackEvent {}

class FetchPacks extends PackEvent {
  FetchPacks(this.groupAddress);

  final String groupAddress;
}

class FetchMorePacks extends PackEvent {}

class FetchPacksMembers extends PackEvent {
  FetchPacksMembers(this.groupAddress);
  final String groupAddress;
}
