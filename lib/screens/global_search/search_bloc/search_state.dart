import 'package:junto_beta_mobile/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchState {}

/// Initial state for the search page.
class InitialSearchState extends SearchState {}

/// Emitted when there is some network activity.
class LoadingSearchState extends SearchState {}

/// Emitted when the server returns search results.
class LoadedSearchState extends SearchState {
  LoadedSearchState(this.results);

  final List<UserProfile> results;
}

/// Sent when the server returns no error but an empty dataset.
class EmptySearchState extends SearchState {}

/// Emitted when the server returns an error.
class ErrorSearchState extends SearchState {
  ErrorSearchState(this.message);

  final String message;
}
