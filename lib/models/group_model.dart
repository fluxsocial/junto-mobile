import 'package:flutter/material.dart';

class Group {
  Group({
    @required this.address,
    @required this.creator,
    @required this.createdAt,
    @required this.privacy,
    @required this.groupType,
    @required this.groupData,
  });

  factory Group.fromMap(Map<String, dynamic> json) => Group(
        address: json['address'],
        creator: json['creator'],
        createdAt: DateTime.parse(json['created_at']),
        privacy: json['privacy'],
        groupType: json['group_type'],
        groupData: GroupData.fromJson(json['group_data']),
      );
  final String address;
  final String creator;
  final DateTime createdAt;
  final String privacy;
  final String groupType;
  final GroupData groupData;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'address': address,
        'creator': creator,
        'created_at': createdAt.toIso8601String(),
        'privacy': privacy,
        'group_type': groupType,
        'group_data': groupData.toJson(),
      };
}

class GroupData {
  GroupData({
    this.description,
    this.name,
    this.photo,
    this.principles,
    this.sphereHandle,
  });

  GroupData.fromJson(Map<String, dynamic> json) {
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
