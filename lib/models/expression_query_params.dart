import 'package:freezed_annotation/freezed_annotation.dart';

part 'expression_query_params.freezed.dart';
part 'expression_query_params.g.dart';

enum ExpressionContextType {
  Dos,
  FollowPerspective,
  Collective,
  Group,
  ConnectPerspective
}

/// ?dos=int/null &
/// ?context=id/null & ?channels=[String, ...] &
/// ?context_type=(Dos, FollowPerspective(pass uuid in context), ConnectPerspective(pass uuid in context), Collective, Group(pass uuid in context) ) &
/// ?pagination_position=int &
/// ?last_timestamp = ISO8601 timestamp (rfc3339) (optional)
@freezed
abstract class ExpressionQueryParams with _$ExpressionQueryParams {
  factory ExpressionQueryParams(
    ExpressionContextType contextType,
    String paginationPosition, {
    String dos,
    String context,
    @JsonKey(toJson: ListToString.toJson) List<String> channels,
  }) = _ExpressionQueryParams;

  factory ExpressionQueryParams.fromJson(Map<String, dynamic> json) =>
      _$ExpressionQueryParamsFromJson(json);
}

class ListToString {
  static String toJson(List<String> value) {
    if (value != null) {
    final list = value.join('", "');
      return '["$list"]';
    } else {
      return null;
    }
  }
}
