part of 'perspectives_bloc.dart';

abstract class PerspectivesEvent {}

class FetchPerspectives extends PerspectivesEvent {}

class CreatePerspective extends PerspectivesEvent {}

class RemovePerspective extends PerspectivesEvent {}

// class EditPerspective extends PerspectivesEvent {}
