part of 'collective_bloc.dart';

@immutable
abstract class CollectiveState {}

class CollectiveInitial extends CollectiveState {}

class CollectivePopulated extends CollectiveState {
  CollectivePopulated(this.results);
  final List<ExpressionResponse> results;
}

class CollectiveLoading extends CollectiveState {}

class CollectiveError extends CollectiveState {}
