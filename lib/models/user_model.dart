import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/models/den_model.dart';
import 'package:junto_beta_mobile/models/pack.dart';
import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:meta/meta.dart';

part 'user_model.g.dart';

/// Generates a stripped down version of [UserProfile].
/// Mostly used for overviews and user tiles.
class SlimUserResponse {
  const SlimUserResponse({
    @required this.name,
    @required this.username,
    @required this.address,
  });

  factory SlimUserResponse.fromJson(Map<String, dynamic> map) {
    return SlimUserResponse(
      name: map['name'] as String,
      username: map['username'] as String,
      address: map['address'] as String,
    );
  }

  final String name;
  final String username;
  final String address;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SlimUserResponse &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          username == other.username &&
          address == other.address);

  @override
  int get hashCode => name.hashCode ^ username.hashCode ^ address.hashCode;

  @override
  String toString() => 'SlimUserResponse{'
      'name: $name username: $username,   address: $address }';

  SlimUserResponse copyWith({
    String name,
    String username,
    String address,
  }) {
    return SlimUserResponse(
      name: name ?? this.name,
      username: username ?? this.username,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, String>{
      'name': name,
      'username': username,
      'address': address,
    };
  }
}

/// Class used to store the profile information of a user.
/// Contains the [address], [name], [bio],
/// [profilePicture], [verified].
@HiveType(typeId: 1)
class UserProfile extends HiveObject {
  UserProfile({
    @required this.address,
    @required this.name,
    @required this.bio,
    @required this.location,
    @required this.profilePicture,
    @required this.backgroundPhoto,
    @required this.verified,
    @required this.username,
    @required this.website,
    @required this.gender,
    this.email,
    this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      address: json['address'] as String,
      name: json['name'] as String,
      bio: json['bio'] as String,
      location:
          json['location'] != null ? List<String>.from(json['location']) : null,
      profilePicture: json['profile_picture'] != null
          ? List<String>.from(json['profile_picture'])
          : null,
      backgroundPhoto: json['background_photo'],
      verified: json['verified'] as bool,
      username: json['username'] as String,
      website:
          json['website'] != null ? List<String>.from(json['website']) : null,
      gender: json['gender'] != null ? List<String>.from(json['gender']) : null,
      email: json['email'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  /// User address
  @HiveField(0)
  final String address;

  ///  Name of the author
  @HiveField(1)
  final String name;

  /// Author's biography
  @HiveField(2)
  final String bio;

  /// Author's location
  @HiveField(3)
  final List<String> location;

  /// Url of the author's profile image
  @HiveField(4)
  final List<String> profilePicture;

  // URL of background photo
  @HiveField(5)
  final String backgroundPhoto;

  /// Whether the given user account has been verified
  @HiveField(6)
  final bool verified;

  /// Username of the given user.
  @HiveField(7)
  final String username;

  /// List of websites a user can upload
  @HiveField(8)
  final List<String> website;

  /// Gender of the user.
  @HiveField(9)
  final List<String> gender;

  // Email of the user
  @HiveField(10)
  final String email;

  // Sign up date
  @HiveField(11)
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          runtimeType == other.runtimeType &&
          address == other.address &&
          name == other.name &&
          bio == other.bio &&
          location == other.location &&
          profilePicture == other.profilePicture &&
          backgroundPhoto == other.backgroundPhoto &&
          verified == other.verified &&
          username == other.username &&
          website == other.website &&
          gender == other.gender &&
          email == other.email &&
          createdAt == other.createdAt);

  @override
  int get hashCode =>
      address.hashCode ^
      name.hashCode ^
      bio.hashCode ^
      location.hashCode ^
      profilePicture.hashCode ^
      backgroundPhoto.hashCode ^
      verified.hashCode ^
      username.hashCode ^
      website.hashCode ^
      gender.hashCode ^
      email.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'UserProfile{'
        ' address: $address,'
        ' name: $name,'
        ' bio: $bio,'
        ' location: $location,'
        ' profilePicture: $profilePicture,'
        ' backgroundPhoto: $backgroundPhoto'
        ' verified: $verified,'
        ' username: $username,'
        ' website: $website,'
        ' gender: $gender,'
        ' email: $email,'
        ' createdAt: $createdAt'
        '}';
  }

  UserProfile copyWith({
    String address,
    String parent,
    String name,
    String bio,
    List<String> location,
    List<String> profilePicture,
    String backgroundPhoto,
    bool verified,
    String username,
    List<String> website,
    List<String> gender,
    String email,
  }) {
    return UserProfile(
      address: address ?? this.address,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      profilePicture: profilePicture ?? this.profilePicture,
      backgroundPhoto: backgroundPhoto ?? this.backgroundPhoto,
      verified: verified ?? this.verified,
      username: username ?? this.username,
      website: website ?? this.website,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'address': address,
      'name': name,
      'bio': bio,
      'location': location,
      'profile_picture': profilePicture,
      'background_photo': backgroundPhoto,
      'verified': verified,
      'username': username,
      'website': website,
      'gender': gender,
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class UserData {
  const UserData({
    @required this.privateDen,
    @required this.publicDen,
    @required this.pack,
    @required this.user,
    @required this.userPerspective,
    @required this.connectionPerspective,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      privateDen: json['private_den'] != null
          ? Den.fromJson(json['private_den'])
          : null,
      publicDen:
          json['public_den'] != null ? Den.fromJson(json['public_den']) : null,
      pack:
          json['pack'] != null ? CentralizedPack.fromJson(json['pack']) : null,
      user: UserProfile.fromJson(json['user']),
      userPerspective: json['user_perspective'] != null
          ? PerspectiveModel.fromJson(
              json['user_perspective'],
            )
          : null,
      connectionPerspective: PerspectiveModel.fromJson(
        json['connection_perspective'],
      ),
    );
  }

  final Den privateDen;
  final Den publicDen;
  final CentralizedPack pack;
  final UserProfile user;
  final PerspectiveModel userPerspective;
  final PerspectiveModel connectionPerspective;

  UserData copyWith({
    Den privateDen,
    Den publicDen,
    CentralizedPack pack,
    UserProfile user,
    PerspectiveModel userPerspective,
    PerspectiveModel connectionPerspective,
  }) {
    return UserData(
      privateDen: privateDen ?? this.privateDen,
      publicDen: publicDen ?? this.publicDen,
      pack: pack ?? this.pack,
      user: user ?? this.user,
      userPerspective: userPerspective ?? this.userPerspective,
      connectionPerspective:
          connectionPerspective ?? this.connectionPerspective,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'private_den': privateDen.toJson(),
      'public_den': publicDen.toJson(),
      'pack': pack.toJson(),
      'user': user.toJson(),
      'user_perspective': userPerspective.toJson(),
      'connection_perspective': connectionPerspective.toJson(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserData &&
          runtimeType == other.runtimeType &&
          privateDen == other.privateDen &&
          publicDen == other.publicDen &&
          pack == other.pack &&
          user == other.user &&
          userPerspective == other.userPerspective &&
          connectionPerspective == other.connectionPerspective);

  @override
  int get hashCode =>
      privateDen.hashCode ^
      publicDen.hashCode ^
      pack.hashCode ^
      user.hashCode ^
      userPerspective.hashCode ^
      connectionPerspective.hashCode;
}
