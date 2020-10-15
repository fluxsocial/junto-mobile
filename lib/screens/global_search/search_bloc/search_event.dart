import 'package:junto_beta_mobile/screens/global_search/search_bloc/bloc.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchEvent {}

class SearchingEvent extends SearchEvent {
  SearchingEvent(this.query, this.username);

  final String query;
  final bool username;
}

class SearchingChannelEvent extends SearchEvent {
  SearchingChannelEvent(this.query);

  final String query;
}

class FetchMoreSearchResEvent extends SearchEvent {
  FetchMoreSearchResEvent();
}
