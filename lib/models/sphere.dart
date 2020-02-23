import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:meta/meta.dart';

class Sphere {
  const Sphere({
    @required this.sphereTitle,
    @required this.sphereMembers,
    @required this.sphereImage,
    @required this.sphereHandle,
    @required this.sphereDescription,
  });

  final String sphereTitle;
  final String sphereMembers;
  final String sphereImage;
  final String sphereHandle;
  final String sphereDescription;

  static List<Sphere> fetchAll() {
    return <Sphere>[
      const Sphere(
        sphereTitle: 'Ecstatic Dance',
        sphereMembers: '12000',
        sphereImage: '',
        sphereHandle: 'ecstaticdance',
        sphereDescription:
            'Ecstatic dance is a space for movement, rhythm, non-judgment, and '
            'expression in its purest form. Come groove out with us!',
      ),
      const Sphere(
        sphereTitle: 'Flutter NYC',
        sphereMembers: '690',
        sphereImage: '',
        sphereHandle: 'flutternyc',
        sphereDescription:
            'Connect with other members in the Flutter NYC community and learn'
            ' about this amazing technology!',
      ),
      const Sphere(
        sphereTitle: 'Zen',
        sphereMembers: '77',
        sphereImage: '',
        sphereHandle: 'zen',
        sphereDescription:
            '"To a mind that is still, the whole universe surrenders"',
      ),
      const Sphere(
        sphereTitle: 'JUNTO Core',
        sphereMembers: '7',
        sphereImage: '',
        sphereHandle: 'juntocore',
        sphereDescription: 'Junto Core team happenings',
      ),
      const Sphere(
        sphereTitle: 'Holochain',
        sphereMembers: '22',
        sphereImage: '',
        sphereHandle: 'holochain',
        sphereDescription:
            'Holochain is a framework to build scalable, distributed applications.',
      ),
    ];
  }
}

class CentralizedSphere {
  CentralizedSphere({
    this.name,
    this.privacy,
    this.sphereHandle,
    this.description,
    this.principles,
    this.facilitators,
    this.photo,
    this.members,
  });

  factory CentralizedSphere.fromJson(Map<String, dynamic> json) {
    return CentralizedSphere(
      name: json['name'],
      privacy: json['privacy'],
      sphereHandle: json['sphere_handle'],
      description: json['description'],
      principles: json['principles'],
      facilitators: json['facilitators'].cast<String>(),
      photo: json['photo'],
      members: json['members'].cast<String>(),
    );
  }

  final String name;
  final String privacy;
  final String sphereHandle;
  final String description;
  final String principles;
  final List<String> facilitators;
  final String photo;
  final List<String> members;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'privacy': privacy,
      'sphere_handle': sphereHandle,
      'description': description,
      'principles': principles,
      'facilitators': facilitators,
      'photo': photo,
      'members': members,
    };
  }

  CentralizedSphere copyWith(
      {String name,
      String privacy,
      String sphereHandle,
      String description,
      String principles,
      List<String> facilitators,
      String photo,
      List<String> members}) {
    return CentralizedSphere(
        name: name ?? this.name,
        privacy: privacy ?? this.privacy,
        sphereHandle: sphereHandle ?? this.sphereHandle,
        description: description ?? this.description,
        members: members ?? this.members,
        photo: photo ?? this.photo,
        facilitators: facilitators ?? this.facilitators,
        principles: principles ?? this.principles);
  }
}

/// Response sent back from the server when creating a sphere
class CentralizedSphereResponse {
  CentralizedSphereResponse({
    @required this.address,
    @required this.creator,
    @required this.createdAt,
    @required this.privacy,
    @required this.groupType,
    @required this.groupData,
    @required this.users,
  });

  factory CentralizedSphereResponse.fromJson(Map<String, dynamic> json) {
    return CentralizedSphereResponse(
      address: json['address'],
      creator: json['creator'],
      createdAt: RFC3339.parseRfc3339(json['created_at']),
      privacy: json['privacy'],
      groupType: json['group_type'],
      groupData: GroupDataSphere.fromJson(json['group_data']),
      users: _parseUsers(json['users']),
    );
  }

  final String address;
  final String creator;
  final DateTime createdAt;
  final String privacy;
  final String groupType;
  final GroupDataSphere groupData;
  final List<Users> users;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['creator'] = creator;
    data['created_at'] = createdAt.toIso8601String();
    data['privacy'] = privacy;
    data['group_type'] = groupType;
    if (groupData != null) {
      data['group_data'] = groupData.toJson();
    }
    if (users != null) {
      data['users'] = users.map((Users user) => user.toJson()).toList();
    }
    return data;
  }

  static List<Users> _parseUsers(List<dynamic> _listData) {
    if (_listData != null && _listData.isNotEmpty) {
      _listData.map((dynamic userData) {
        return Users.fromJson(userData);
      }).toList();
    }
    return <Users>[];
  }
}

class Users {
  Users({
    @required this.user,
    @required this.permissionLevel,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      user: UserProfile.fromMap(json['user']),
      permissionLevel: json['permission_level'],
    );
  }

  final UserProfile user;
  final String permissionLevel;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user.toMap();
    }
    data['permission_level'] = permissionLevel;
    return data;
  }
}

class Principle {
  const Principle({
    @required this.title,
    @required this.body,
  });

  factory Principle.fromMap(Map<String, dynamic> map) {
    return Principle(
      title: map['title'] as String,
      body: map['body'] as String,
    );
  }

  final String title;
  final String body;

  Map<String, dynamic> toMap() {
    return <String, String>{
      'title': title,
      'body': body,
    };
  }
}
