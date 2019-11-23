import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/utils.dart';

class Perspective {
  const Perspective({@required this.name, @required this.members});

  factory Perspective.fromMap(Map<String, dynamic> map) {
    return Perspective(
      name: map['name'],
      members: List<String>.from(
        map['name'].map((dynamic data) => data.toString()).toList(),
      ),
    );
  }

  final String name;
  final List<String> members;

  static List<Perspective> fetchAll() {
    return <Perspective>[
      const Perspective(name: 'NYC 🗽🏙️  ', members: <String>[]),
      const Perspective(name: 'Design', members: <String>[]),
      const Perspective(name: 'Meditation', members: <String>[]),
      const Perspective(name: 'Hoops 🏀', members: <String>[]),
      const Perspective(name: 'Austrian Economics📈', members:<String> []),
      const Perspective(name: 'Holochain ♓', members: <String>[]),
    ];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'members': members,
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
    this.userCount,
    this.users,
  });

  factory CentralizedPerspective.fromMap(Map<String, dynamic> map) {
    return CentralizedPerspective(
      address: map['address'] as String,
      name: map['name'] as String,
      creator: map['creator'] as String,
      createdAt: RFC3339.parseRfc3339(map['created_at']),
      isDefault: map['is_default'] as bool,
      userCount: map['user_count'] != null ? map['user_count'] as int : null,
      users: map['users'] != null ? _parseUsers(map['users']) : null,
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

  /// Number of users in the given perspective
  final int userCount;

  /// List of users associated with the given perspective.
  final List<UserProfile> users;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'name': name,
      'creator': creator,
      'created_at': createdAt?.toIso8601String(),
      'is_default': isDefault,
      'user_count': userCount,
    };
  }

  static List<UserProfile> _parseUsers(List<dynamic> _listData) {
    if (_listData != null && _listData.isNotEmpty) {
      _listData.map((dynamic userData) {
        return UserProfile.fromMap(userData);
      }).toList();
    }
    return <UserProfile>[];
  }
}
