part of 'den_bloc.dart';

@immutable
abstract class DenState {}

class DenInitial extends DenState {}

class DenLoadingState extends DenState {}

class DenLoadedState extends DenState {
  final List<ExpressionResponse> expressions;

  DenLoadedState(this.expressions);
}

class DenEmptyState extends DenState {}

class DenErrorState extends DenState {
  DenErrorState(this.message);
  final String message;
}
