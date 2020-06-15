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

  factory Collective.fromJson(Map<String, dynamic> json) => Collective(
        address: json['address'],
        creator: json['creator'],
        createdAt: DateTime.parse(json['created_at']),
        privacy: json['privacy'],
        name: json['name'],
        parent: json['parent'],
      );

  /// Address of the [Collective] on the server
  final String address;

  /// UUID of the [Collective] creator
  final String creator;

  /// Date [Collective] was created.
  final DateTime createdAt;

  /// Privacy setting of the given [Collective]. Public, Private, Shared
  final String privacy;

  /// [Collective] name
  final String name;

  /// Parent Collection address if any. Only applies to nest collections.
  final String parent;

  Map<String, dynamic> toJson() {
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

  factory NestedCollections.fromJson(Map<String, dynamic> json) {
    return NestedCollections._(
      nestedCollections: List<Collective>.from(
        json['nested_collections'].map(
          (Map<String, dynamic> collective) => Collective.fromJson(collective),
        ),
      ),
    );
  }

  List<Collective> nestedCollections;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'nested_collections': List<dynamic>.from(
          nestedCollections.map(
            (Collective collective) {
              return collective.toJson();
            },
          ),
        ),
      };
}

/// Object containg the [collective], list of nested collections, [nestedCollections]
/// and list of [expressions] associated with the given collection.
class CollectionResponse {
  CollectionResponse._({
    @required this.collective,
    @required this.nestedCollections,
    @required this.expressions,
  });

  factory CollectionResponse.fromJson(Map<String, dynamic> json) {
    return CollectionResponse._(
      collective: Collective.fromJson(json['collection']),
      nestedCollections: NestedCollections.fromJson(json['nested_collections']),
      expressions: List<ExpressionResponse>.from(
        json['expressions'].map(
          (Map<String, dynamic> expression) =>
              ExpressionResponse.fromJson(expression),
        ),
      ),
    );
  }

  /// Collective
  final Collective collective;

  /// List of [Collective]
  final NestedCollections nestedCollections;

  /// List of [ExpressionResponse]
  final List<ExpressionResponse> expressions;
}
