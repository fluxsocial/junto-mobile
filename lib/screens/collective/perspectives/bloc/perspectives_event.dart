part of 'perspectives_bloc.dart';

abstract class PerspectivesEvent {}

class FetchPerspectives extends PerspectivesEvent {}

class ChangePerspective extends PerspectivesEvent {
  final PerspectiveModel perspectiveModel;
  ChangePerspective(this.perspectiveModel);
}

class CreatePerspective extends PerspectivesEvent {}

class RemovePerspective extends PerspectivesEvent {}

// class EditPerspective extends PerspectivesEvent {}
