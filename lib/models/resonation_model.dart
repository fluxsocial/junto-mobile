class Resonation {
  Resonation({
    this.groupAddress,
    this.expressionAddress,
    this.linkType,
  });

  factory Resonation.fromJson(Map<String, dynamic> json) {
    return Resonation(
      groupAddress: json['group_address'],
      expressionAddress: json['expression_address'],
      linkType: json['link_type'],
    );
  }

  /// Address of the Group.
  final String groupAddress;

  /// Expression address.
  final String expressionAddress;

  /// Can be "Resonation, DirectPost, CollectivePost"
  final String linkType;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'group_address': groupAddress,
        'expression_address': expressionAddress,
        'link_type': linkType,
      };
}
