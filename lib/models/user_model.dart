import 'package:junto_beta_mobile/models/den_model.dart';
import 'package:junto_beta_mobile/models/pack.dart';
import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:meta/meta.dart';

/// Class used to store the profile information of a user.
/// Contains the [address], [parent], [firstName], [lastName], [bio],
/// [profilePicture], [verified].
class UserProfile {
  const UserProfile({
    @required this.address,
    @required this.name,
    @required this.bio,
    @required this.location,
    @required this.profilePicture,
    @required this.verified,
    @required this.username,
    @required this.website,
    @required this.gender,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      address: map['address'] as String,
      name: map['name'] as String,
      bio: map['bio'] as String,
      location: List<String>.from(map['location']),
      profilePicture: map['profilePicture'] as String,
      verified: map['verified'] as bool,
      username: map['username'] as String,
      website: List<String>.from(map['website']),
      gender: List<String>.from(map['gender']),
    );
  }

  /// Location
  final String address;

  ///  Name of the author
  final String name;

  /// Author's biography
  final String bio;

  /// Author's location
  final List<String> location;

  /// Url of the author's profile image
  final String profilePicture;

  /// Whether the given user account has been verified
  final bool verified;

  /// Username of the given user.
  final String username;

  /// List of websites a user can upload
  final List<String> website;

  /// Gender of the user.
  final List<String> gender;

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
          verified == other.verified &&
          username == other.username &&
          website == other.website &&
          gender == other.gender);

  @override
  int get hashCode =>
      address.hashCode ^
      name.hashCode ^
      bio.hashCode ^
      location.hashCode ^
      profilePicture.hashCode ^
      verified.hashCode ^
      username.hashCode ^
      website.hashCode ^
      gender.hashCode;

  @override
  String toString() {
    return 'UserProfile{' +
        ' address: $address,' +
        ' name: $name,' +
        ' bio: $bio,' +
        ' location: $location,' +
        ' profilePicture: $profilePicture,' +
        ' verified: $verified,' +
        ' username: $username,' +
        ' website: $website,' +
        ' gender: $gender,' +
        '}';
  }

  UserProfile copyWith({
    String address,
    String parent,
    String name,
    String bio,
    List<String> location,
    String profilePicture,
    bool verified,
    String username,
    List<String> website,
    List<String> gender,
  }) {
    return UserProfile(
      address: address ?? this.address,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      profilePicture: profilePicture ?? this.profilePicture,
      verified: verified ?? this.verified,
      username: username ?? this.username,
      website: website ?? this.website,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'name': name,
      'bio': bio,
      'location': location,
      'profile_picture': profilePicture,
      'verified': verified,
      'username': username,
      'website': website,
      'gender': gender,
    };
  }
}

/// Detials used during user authentication.
abstract class UserAuthDetails {
  String get email;

  String get password;

  bool get isComplete;
}

/// User auth details used during login. Email and Password must
/// not be null or empty.
class UserAuthLoginDetails implements UserAuthDetails {
  UserAuthLoginDetails({
    @required this.email,
    @required this.password,
  });

  @override
  final String email;
  @override
  final String password;

  @override
  bool get isComplete => email != null && password != null;
}

/// Implementation of UserAuthDetails for registering a new user.
/// All fields must not null or blank.
class UserAuthRegistrationDetails implements UserAuthDetails {
  UserAuthRegistrationDetails({
    @required this.email,
    @required this.password,
    @required this.name,
    @required this.username,
    @required this.bio,
    this.location,
    this.profileImage,
  });

  @override
  final String email;
  @override
  final String password;
  final String name;
  final String username;
  final String bio;
  final String location;
  final String profileImage;

  @override
  bool get isComplete => email != null && password != null && name != null;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'name': name,
      'profile_picture': profileImage,
      'bio': bio
    };
  }
}

class UserData {
  UserData({
    @required this.privateDen,
    @required this.publicDen,
    @required this.pack,
    @required this.user,
    @required this.userPerspective,
    @required this.connectionPerspective,
  });

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      privateDen: map['private_den'] != null
          ? CentralizedDen.fromMap(map['private_den'])
          : null,
      publicDen: map['public_den'] != null
          ? CentralizedDen.fromMap(map['public_den'])
          : null,
      pack: CentralizedPack.fromMap(map['pack']),
      user: UserProfile.fromMap(map['user']),
      userPerspective: CentralizedPerspective.fromMap(
        map['user_perspective'],
      ),
      connectionPerspective: CentralizedPerspective.fromMap(
        map['connection_perspective'],
      ),
    );
  }

  final CentralizedDen privateDen;
  final CentralizedDen publicDen;
  final CentralizedPack pack;
  final UserProfile user;
  final CentralizedPerspective userPerspective;
  final CentralizedPerspective connectionPerspective;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'private_den': privateDen.toJson(),
      'public_den': publicDen.toJson(),
      'pack': pack.toMap(),
      'user': user.toMap(),
      'user_perspective': userPerspective.toMap(),
      'connection_perspective': connectionPerspective.toMap(),
    };
  }

  @override
  String toString() {
    return 'User Data: privateDen: $privateDen, publicDen: $publicDen, pack: $pack, user: $user, userPerspective: $userPerspective connectionPerspective $connectionPerspective ';
  }
}
