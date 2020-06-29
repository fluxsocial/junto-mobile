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
  final String lastTimestamp;

  ExpressionQueryParams({
    this.contextType,
    this.paginationPosition = '0',
    this.dos,
    this.context,
    this.channels,
    this.name,
    this.lastTimestamp,
  });

  static const ExpressionContextTypeEnumMap = {
    ExpressionContextType.Dos: 'Dos',
    ExpressionContextType.FollowPerspective: 'FollowPerspective',
    ExpressionContextType.Collective: 'Collective',
    ExpressionContextType.Group: 'Group',
    ExpressionContextType.ConnectPerspective: 'ConnectPerspective',
  };

  Map<String, String> toJson() {
    Map<String, String> params = {};
    if (contextType != null) {
      params.putIfAbsent(
        'context_type',
        () => ExpressionContextTypeEnumMap[contextType],
      );
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
      params.putIfAbsent('channels', () => ListToString.toJson(channels));
    }
    if (name != null) {
      params.putIfAbsent('name', () => name);
    }
    if (lastTimestamp != null) {
      params.putIfAbsent('last_timestamp', () => lastTimestamp);
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
