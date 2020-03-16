part of 'collective_bloc.dart';

@immutable
abstract class CollectiveEvent {}

class CollectiveFetch extends CollectiveEvent {
  CollectiveFetch(this.contextType, [this.dos = 0, this.paginationPos = 0]);
  final String contextType;
  final int dos;
  final int paginationPos;
}

class CollectiveRefresh extends CollectiveEvent {}
