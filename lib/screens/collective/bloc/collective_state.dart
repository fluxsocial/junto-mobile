import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:junto_beta_mobile/models/expression.dart';

part 'collective_state.freezed.dart';

@freezed
abstract class CollectiveState with _$CollectiveState {
  factory CollectiveState.initial() = CollectiveInitial;
  factory CollectiveState.populated(List<ExpressionResponse> results,
      [bool loadingMore,
      @Default('JUNTO') String name,
      bool availableMore]) = CollectivePopulated;
  factory CollectiveState.loading() = CollectiveLoading;
  factory CollectiveState.error() = CollectiveError;
}
