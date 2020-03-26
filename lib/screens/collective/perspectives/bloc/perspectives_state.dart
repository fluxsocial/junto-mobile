part of 'perspectives_bloc.dart';

abstract class PerspectivesState extends Equatable {
  const PerspectivesState();
}

class PerspectivesInitial extends PerspectivesState {
  @override
  List<Object> get props => [];
}

class PerspectivesFetched extends PerspectivesState {
  const PerspectivesFetched(this.perspectives);

  final List<PerspectiveModel> perspectives;
  @override
  List<Object> get props => [perspectives];
}

class PerspectivesLoading extends PerspectivesState {
  @override
  List<Object> get props => [];
}

class PerspectivesError extends PerspectivesState {
  @override
  List<Object> get props => [];
}
