part of 'collective_bloc.dart';

@immutable
abstract class CollectiveEvent {}

class FetchCollective extends CollectiveEvent {
  FetchCollective(this.param);

  final ExpressionQueryParams param;
}

class FetchMoreCollective extends CollectiveEvent {}

class RefreshCollective extends CollectiveEvent {}

//TODO: switch perspectives via bloc
// class ChangePerspective extends CollectiveEvent {
//   ChangePerspective(this.perspective);
//   final PerspectiveModel perspective;
// }
