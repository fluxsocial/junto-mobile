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
class ExpressionQueryParams {
  final ExpressionContextType contextType;
  final String paginationPosition;
  final String dos;
  final String context;
  final List<String> channels;
  final String name;

  ExpressionQueryParams({
    this.contextType,
    this.paginationPosition = '0',
    this.dos,
    this.context,
    this.channels,
    this.name,
  });
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
