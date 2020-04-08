import 'package:meta/meta.dart';

@immutable
abstract class SearchEvent {}

class SearchingEvent extends SearchEvent {
  SearchingEvent(this.query, this.username);

  final String query;
  final bool username;
}

class FetchMoreSearchResEvent extends SearchEvent {
  FetchMoreSearchResEvent();
}
