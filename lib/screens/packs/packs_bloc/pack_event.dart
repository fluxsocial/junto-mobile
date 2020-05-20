part of 'pack_bloc.dart';

@immutable
abstract class PackEvent {}

class FetchPacks extends PackEvent {
  final String group;
  final String channel;

  FetchPacks({
    this.group,
    this.channel,
  });
}

class RefreshPacks extends PackEvent {}

class FetchMorePacks extends PackEvent {}

class FetchPacksMembers extends PackEvent {
  FetchPacksMembers(this.groupAddress);

  final String groupAddress;
}

class FetchMorePacksMembers extends PackEvent {}

class DeletePackExpression extends PackEvent {
  DeletePackExpression(this.expressionAddress);

  final String expressionAddress;
}
