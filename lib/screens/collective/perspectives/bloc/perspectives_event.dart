part of 'perspectives_bloc.dart';

abstract class PerspectivesEvent {}

class FetchPerspectives extends PerspectivesEvent {}

class ChangePerspective extends PerspectivesEvent {
  final PerspectiveModel perspectiveModel;
  ChangePerspective(this.perspectiveModel);
}

class CreatePerspective extends PerspectivesEvent {
  final String name;
  final String description;
  final List<String> members;
  CreatePerspective(this.name, this.description, this.members);
}

class RemovePerspective extends PerspectivesEvent {
  final PerspectiveModel perspective;
  RemovePerspective(this.perspective);
}

// class EditPerspective extends PerspectivesEvent {}
