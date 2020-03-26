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

  Map<String, dynamic> toMap() {
    Map<String, dynamic> params = {};
    if (contextType != null) {
      params.putIfAbsent('context_type', () => contextType);
    }
    if (paginationPosition != null) {
      params.putIfAbsent('pagination_position', () => paginationPosition);
    }
    if (dos != null) {
      params.putIfAbsent('dos', () => dos);
    }
    if (context != null) {
      params.putIfAbsent('context', () => context);
    }
    if (channels != null) {
      params.putIfAbsent('channels', () => channels);
    }
    if (name != null) {
      params.putIfAbsent('name', () => name);
    }
    return params;
  }
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
