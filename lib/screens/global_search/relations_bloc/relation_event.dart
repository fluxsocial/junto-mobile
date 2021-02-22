part of 'relation_bloc.dart';

@immutable
abstract class RelationEvent {}

class FetchRealtionship extends RelationEvent {}

class FetchMoreRelationship extends RelationEvent {}

class SearchRelationship extends RelationEvent {
  final String query;

  SearchRelationship(this.query);
}
