part of 'relation_bloc.dart';

enum RelationContext { following, follower, connections }

@immutable
abstract class RelationEvent {}

class FetchRealtionship extends RelationEvent {
  final RelationContext context;

  FetchRealtionship(this.context);
}

class FetchMoreRelationship extends RelationEvent {
  final RelationContext context;

  FetchMoreRelationship(this.context);
}

class SearchRelationship extends RelationEvent {
  final String query;

  SearchRelationship(this.query);
}
