import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';

/// Object representation of a [Collective]
class Collective {
  Collective({
    this.address,
    this.creator,
    this.createdAt,
    this.privacy,
    this.name,
    this.parent,
  });

  factory Collective.fromMap(Map<String, dynamic> json) => Collective(
        address: json['address'],
        creator: json['creator'],
        createdAt: DateTime.parse(json['created_at']),
        privacy: json['privacy'],
        name: json['name'],
        parent: json['parent'],
      );

  final String address;
  final String creator;
  final DateTime createdAt;
  final String privacy;
  final String name;
  final String parent;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'creator': creator,
      'created_at': createdAt.toIso8601String(),
      'privacy': privacy,
      'name': name,
      'parent': parent,
    };
  }
}

/// List containing [Collective]
class NestedCollections {
  NestedCollections._({
    this.nestedCollections,
  });

  factory NestedCollections.fromMap(Map<String, dynamic> json) {
    return NestedCollections._(
      nestedCollections: List<Collective>.from(
        json['nested_collections'].map(
          (Map<String, dynamic> collective) => Collective.fromMap(collective),
        ),
      ),
    );
  }

  List<Collective> nestedCollections;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'nested_collections': List<dynamic>.from(
          nestedCollections.map(
            (Collective collective) {
              return collective.toMap();
            },
          ),
        ),
      };
}

class CollectionResponse {
  CollectionResponse._({
    @required this.collective,
    @required this.nestedCollections,
    @required this.expressions,
  });
  factory CollectionResponse.fromMap(Map<String, dynamic> json) {
    return CollectionResponse._(
      collective: Collective.fromMap(json['collection']),
      nestedCollections: NestedCollections.fromMap(json['nested_collections']),
      expressions: List<CentralizedExpressionResponse>.from(
        json['expressions'].map(
          (Map<String, dynamic> expression) => CentralizedExpressionResponse.fromMap(expression),
        ),
      ),
    );
  }
  final Collective collective;
  final NestedCollections nestedCollections;
  final List<CentralizedExpressionResponse> expressions;
}
