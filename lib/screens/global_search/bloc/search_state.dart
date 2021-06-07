import 'package:junto_beta_mobile/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchState {}

@immutable
abstract class SearchUserState extends SearchState {}

@immutable
abstract class SearchChannelState extends SearchState {}

/// Initial state for the search page.
class InitialSearchState extends SearchUserState {}

/// Emitted when there is some network activity.
class LoadingSearchState extends SearchUserState {}

/// Emitted when the server returns search results.
class LoadedSearchState extends SearchUserState {
  LoadedSearchState(this.results);

  final List<UserProfile> results;
}

/// Sent when the server returns no error but an empty dataset.
class EmptySearchState extends SearchUserState {}

/// Emitted when the server returns an error.
class ErrorSearchState extends SearchUserState {
  ErrorSearchState(this.message);

  final String message;
}

/// Initial state for the search page.
class InitialSearchChannelState extends SearchChannelState {}

/// Emitted when there is some network activity.
class LoadingSearchChannelState extends SearchChannelState {}

/// Emitted when the server returns search results.
class LoadedSearchChannelState extends SearchChannelState {
  LoadedSearchChannelState(this.results);

  final List<Channel> results;
}

/// Sent when the server returns no error but an empty dataset.
class EmptySearchChannelState extends SearchChannelState {}

/// Emitted when the server returns an error.
class ErrorSearchChannelState extends SearchChannelState {
  ErrorSearchChannelState(this.message);

  final String message;
}
