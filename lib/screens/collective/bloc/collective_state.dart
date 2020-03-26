part of 'collective_bloc.dart';

@immutable
abstract class CollectiveState {}

class CollectiveInitial extends CollectiveState {}

class CollectivePopulated extends CollectiveState {
  CollectivePopulated(this.results,
      [this.loadingMore = false, this.name = 'JUNTO']);
  final List<ExpressionResponse> results;
  final bool loadingMore;
  final String name;
}

class CollectiveLoading extends CollectiveState {}

class CollectiveError extends CollectiveState {}
