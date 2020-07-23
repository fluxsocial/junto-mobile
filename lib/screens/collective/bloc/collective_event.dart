part of 'collective_bloc.dart';

@immutable
abstract class CollectiveEvent {}

class FetchCollective extends CollectiveEvent {
  FetchCollective(this.param);
 
  final ExpressionQueryParams param;
}

class FetchMoreCollective extends CollectiveEvent {}

class RefreshCollective extends CollectiveEvent {}

class DeleteCollective extends CollectiveEvent {
  DeleteCollective(this.address);
  final String address;
}

//TODO: switch perspectives via bloc
// class ChangePerspective extends CollectiveEvent {
//   ChangePerspective(this.perspective);
//   final PerspectiveModel perspective;
// }
