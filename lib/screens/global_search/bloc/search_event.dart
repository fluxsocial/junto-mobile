import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchEvent {}

class SearchingEvent extends SearchEvent {
  SearchingEvent(this.query, this.username);

  final String query;
  final QueryUserBy username;
}

class SearchingChannelEvent extends SearchEvent {
  SearchingChannelEvent(this.query);

  final String query;
}

class FetchMoreSearchResEvent extends SearchEvent {
  FetchMoreSearchResEvent(this.query, this.username);

  final String query;
  final QueryUserBy username;
}
