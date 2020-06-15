import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/utils.dart';

/// Object representing a group and a sphere. [groupType] determines the
/// return type of [groupData]. Should [groupType] == 'Pack', [GroupDataPack]
/// will be returned. Else [GroupDataSphere] is returned.
class Group {
  const Group({
    @required this.address,
    @required this.creator,
    @required this.createdAt,
    @required this.privacy,
    @required this.groupType,
    @required this.facilitators,
    @required this.members,
    @required this.groupData,
    this.incomingCreator,
  });

  factory Group.fromMap(Map<String, dynamic> json) => Group(
        address: json['address'],
        creator: json['creator'],
        createdAt: RFC3339.parseRfc3339(json['created_at']),
        privacy: json['privacy'],
        groupType: json['group_type'],
        members: json['members'],
        facilitators: json['facilitators'],
        groupData: json['group_type'] == 'Sphere'
            ? GroupDataSphere.fromJson(json['group_data'])
            : GroupDataPack.fromMap(json['group_data']),
      );

  /// Address of the group on the server
  final String address;

  final dynamic creator;

  /// [SlimUserResponse] of the group's creator.
  final SlimUserResponse incomingCreator;

  /// iso string of the time the group was created.
  final DateTime createdAt;

  /// Privacy setting of the given group. ( potential values: Public, Shared, Private),
  final String privacy;

  /// Type of group. Ie: Sphere or Pack
  final String groupType;
  final dynamic facilitators;
  final dynamic members;

  /// Object representation of group type. Value is based on [groupType].
  /// Please see [GroupDataPack] and [GroupDataSphere].
  final dynamic groupData;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'address': address,
        'creator': creator,
        'created_at': createdAt.toIso8601String(),
        'privacy': privacy,
        'group_type': groupType,
        'members': members.toString(),
        'facilitators': facilitators.toString(),
        'group_data': groupData.toJson(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Group &&
          runtimeType == other.runtimeType &&
          address == other.address &&
          creator == other.creator &&
          createdAt == other.createdAt &&
          privacy == other.privacy &&
          groupType == other.groupType &&
          facilitators == other.facilitators &&
          members == other.members &&
          groupData == other.groupData);

  @override
  int get hashCode =>
      address.hashCode ^
      creator.hashCode ^
      createdAt.hashCode ^
      privacy.hashCode ^
      groupType.hashCode ^
      facilitators.hashCode ^
      members.hashCode ^
      groupData.hashCode;

  Group copyWith({
    String address,
    dynamic creator,
    DateTime createdAt,
    String privacy,
    String groupType,
    dynamic facilitators,
    dynamic members,
    dynamic groupData,
  }) {
    return Group(
      address: address ?? this.address,
      creator: creator ?? this.creator,
      createdAt: createdAt ?? this.createdAt,
      privacy: privacy ?? this.privacy,
      groupType: groupType ?? this.groupType,
      facilitators: facilitators ?? this.facilitators,
      members: members ?? this.members,
      groupData: groupData ?? this.groupData,
    );
  }
}

/// Returned when [Group.groupType] == `Pack`.
class GroupDataPack {
  GroupDataPack({@required this.name});

  factory GroupDataPack.fromMap(Map<String, dynamic> map) {
    return GroupDataPack(
      name: map['name'] as String,
    );
  }

  /// Name of pack the user is apart of
  final String name;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
    };
  }
}

/// Returned when [Group.groupType] == `Sphere`.
class GroupDataSphere {
  GroupDataSphere({
    this.description,
    this.name,
    this.photo,
    this.principles,
    this.sphereHandle,
  });

  GroupDataSphere.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    name = json['name'];
    photo = json['photo'];
    principles = json['principles'];
    sphereHandle = json['sphere_handle'];
  }

  String description;
  String name;
  String photo;
  String principles;
  String sphereHandle;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['name'] = name;
    data['photo'] = photo;
    data['principles'] = principles;
    data['sphere_handle'] = sphereHandle;
    return data;
  }
}

/// Response object sent back from centralized api for user groups.
class UserGroupsResponse {
  UserGroupsResponse._({
    this.owned,
    this.associated,
  });

  factory UserGroupsResponse.fromMap(Map<String, dynamic> json) =>
      UserGroupsResponse._(
        owned: List<Group>.from(
          json['owned'].map(
            (dynamic _group) => Group.fromMap(_group),
          ),
        ),
        associated: List<Group>.from(
          json['associated'].map(
            (dynamic group) => Group.fromMap(group),
          ),
        ),
      );

  /// List of Spheres or Packs owned by the user
  List<Group> owned;

  /// List of Spheres or Packs a users is apart of
  List<Group> associated;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'owned': List<dynamic>.from(
          owned.map(
            (Group _group) => _group.toJson(),
          ),
        ),
        'associated': List<dynamic>.from(
          associated.map(
            (Group _group) => _group.toJson(),
          ),
        ),
      };
}
