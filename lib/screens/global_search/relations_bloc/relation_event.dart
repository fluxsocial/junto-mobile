part of 'relation_bloc.dart';

enum RelationContext { following, follower, connections }

@immutable
abstract class RelationEvent {}

class FetchRealtionship extends RelationEvent {
  final List<RelationContext> context;
  final String query;

  FetchRealtionship(this.context, this.query);
}

class FetchMoreRelationship extends RelationEvent {
  final RelationContext context;
  final String query;

  FetchMoreRelationship(this.context, this.query);
}
