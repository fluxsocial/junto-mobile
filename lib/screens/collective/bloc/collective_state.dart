part of 'collective_bloc.dart';

@immutable
abstract class CollectiveState {}

class CollectiveInitial extends CollectiveState {}

class CollectivePopulated extends CollectiveState {
  CollectivePopulated(this.results, [this.loadingMore = false]);
  final List<ExpressionResponse> results;
  final bool loadingMore;
}

class CollectiveLoading extends CollectiveState {}

class CollectiveError extends CollectiveState {}
