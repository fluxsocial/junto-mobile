import 'package:junto_beta_mobile/models/den_model.dart';
import 'package:junto_beta_mobile/models/pack.dart';
import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:meta/meta.dart';

/// Class used to store the profile information of a user.
/// Contains the [address], [parent], [firstName], [lastName], [bio],
/// [profilePicture], [verified].
class UserProfile {
  UserProfile({
    this.address,
    this.parent,
    this.name, 
    this.bio,
    this.location,
    this.profilePicture,
    this.verified,
    this.username,
  });

  /// Converts the information contained in this class to a map
  factory UserProfile.fromMap(Map<String, dynamic> json) {
    return UserProfile(
        address: json['address'],
        parent: json['parent'] ?? '',
        name: json['name'],
        bio: json['bio'],
        location: json['location'],
        profilePicture: json['profile_picture'] ?? '',
        verified: json['verified'],
        username: json['username'] ?? '');
  }

  /// Location
  final String address;

  /// Parent's address
  final String parent;

  ///  Name of the author
  final String name;

  /// Author's biography
  final String bio;

  /// Author's location
  final String location;  

  /// Url of the author's profile image
  final String profilePicture;

  /// Whether the given user account has been verified
  final bool verified;

  /// Username of the given user.
  final String username;

  /// Converts the class to a map
  Map<String, dynamic> toMap() => <String, dynamic>{
        'address': address,
        'parent': parent,
        'name': name,
        'bio': bio,
        'location': location,
        'profile_picture': profilePicture,
        'verified': verified,
        'username': username
      };

  @override
  String toString() {
    return 'UserProfile: address: $address, parent: $parent, name: '
        '$name, bio: $bio,'
        ' location: $location,'
        ' profilePicture: $profilePicture, verified: $verified,'
        ' username: $username';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          address == other.address &&
          parent == other.parent &&
          name == other.name &&
          bio == other.bio &&
          location == other.location &&
          profilePicture == other.profilePicture &&
          verified == other.verified &&
          username == other.username;

  @override
  int get hashCode =>
      address.hashCode ^
      parent.hashCode ^
      name.hashCode ^
      bio.hashCode ^
      location.hashCode ^
      profilePicture.hashCode ^
      verified.hashCode ^
      username.hashCode;
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
    );
  }

  final CentralizedDen privateDen;
  final CentralizedDen publicDen;
  final CentralizedPack pack;
  final UserProfile user;
  final CentralizedPerspective userPerspective;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'private_den': privateDen.toJson(),
      'public_den': publicDen.toJson(),
      'pack': pack.toMap(),
      'user': user.toMap(),
      'user_perspective': userPerspective.toMap(),
    };
  }

  @override
  String toString() {
    return 'UserData{privateDen: $privateDen, publicDen: $publicDen, pack: $pack, user: $user, userPerspective: $userPerspective}';
  }
}
