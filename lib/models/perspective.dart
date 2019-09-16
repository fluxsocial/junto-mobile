import 'package:flutter/material.dart';

class Perspective {
  const Perspective({@required this.name});

  factory Perspective.fromMap(Map<String, dynamic> map) {
    return Perspective(
      name: map['name'],
    );
  }

  final String name;

  static List<Perspective> fetchAll() {
    return <Perspective>[
      const Perspective(name: 'NYC 🗽🏙️  '),
      const Perspective(name: 'Design'),
      const Perspective(name: 'Meditation'),
      const Perspective(name: 'Hoops 🏀'),
      const Perspective(name: 'Austrian Economics📈'),
      const Perspective(name: 'Holochain ♓'),
    ];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }
}

/// Model containing the [address], [parent], [name], [privacy] and
/// [channelType] of the given Perspective.
class PerspectiveResponse {
  PerspectiveResponse({
    @required this.address,
    @required this.parent,
    @required this.name,
    @required this.privacy,
    @required this.channelType,
  });

  /// Creates a [PerspectiveResponse] from the decoded json data.
  factory PerspectiveResponse.fromMap(Map<String, dynamic> json) {
    return PerspectiveResponse(
      address: json['address'],
      parent: json['entry']['parent'],
      name: json['entry']['name'],
      privacy: json['entry']['privacy'],
      channelType: json['entry']['channel_type'],
    );
  }

  /// Address of the given [Perspective] on the server
  final String address;

  /// The object's parent
  final String parent;

  /// Name of the [Perspective]
  final String name;

  /// Whether this [Perspective] is open or private.
  final String privacy;

  /// String identifying the type of channel. `Perspective`
  final String channelType;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'entry': <String, dynamic>{
          'parent': parent,
          'name': name,
          'privacy': privacy,
          'channel_type': channelType,
        }
      };
}

/// Object representation of a perspective returned by the centralized server.
class CentralizedPerspective {
  CentralizedPerspective({
    @required this.address,
    @required this.name,
    @required this.creator,
    @required this.createdAt,
    @required this.isDefault,
  });

  factory CentralizedPerspective.fromMap(Map<String, dynamic> map) {
    return CentralizedPerspective(
      address: map['address'] as String,
      name: map['name'] as String,
      creator: map['creator'] as String,
      createdAt: DateTime.parse(map['created_at']),
      isDefault: map['is_default'] as bool,
    );
  }

  /// Address of perspective
  final String address;

  /// Name of given perspective
  final String name;

  /// The UUID of the creator
  final String creator;

  /// Needs to be converted from an ISO 8601 String
  final DateTime createdAt;
  final bool isDefault;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'name': name,
      'creator': creator,
      'createdAt': createdAt.toIso8601String(),
      'isDefault': isDefault,
    };
  }
}
