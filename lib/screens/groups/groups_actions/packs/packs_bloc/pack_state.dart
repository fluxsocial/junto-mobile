part of 'pack_bloc.dart';

@immutable
abstract class PackState {}

class PackInitial extends PackState {}

class PacksLoading extends PackState {}

class PacksLoaded extends PackState {
  PacksLoaded(this.publicExpressions, this.privateExpressions);
  final QueryResults<ExpressionResponse> publicExpressions;
  final QueryResults<ExpressionResponse> privateExpressions;
}

class PacksError extends PackState {
  PacksError([this.message]);
  final String message;
}

// Experimental for now, maybe we can use this to test for an "Empty" state
class PacksEmpty extends PackState {}
