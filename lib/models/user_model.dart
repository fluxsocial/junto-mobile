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
    this.firstName,
    this.lastName,
    this.bio,
    this.profilePicture,
    this.verified,
    this.username,
  });

  /// Converts the information contained in this class to a map
  factory UserProfile.fromMap(Map<String, dynamic> json) {
    return UserProfile(
        address: json['address'],
        parent: json['parent'] ?? '',
        firstName: json['first_name'],
        lastName: json['last_name'],
        bio: json['bio'],
        profilePicture: json['profile_picture'] ?? '',
        verified: json['verified'],
        username: json['username'] ?? '');
  }

  /// Location
  final String address;

  /// Parent's address
  final String parent;

  /// First Name of the author
  final String firstName;

  /// Last Name of the author
  final String lastName;

  /// Author's biography
  final String bio;

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
        'first_name': firstName,
        'last_name': lastName,
        'bio': bio,
        'profile_picture': profilePicture,
        'verified': verified,
        'username': username
      };

  @override
  String toString() {
    return 'UserProfile: address: $address, parent: $parent, firstName: '
        '$firstName, lastName: $lastName, bio: $bio,'
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
          firstName == other.firstName &&
          lastName == other.lastName &&
          bio == other.bio &&
          profilePicture == other.profilePicture &&
          verified == other.verified &&
          username == other.username;

  @override
  int get hashCode =>
      address.hashCode ^
      parent.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      bio.hashCode ^
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
    @required this.firstName,
    @required this.lastName,
    @required this.username,
    @required this.bio,
    this.profileImage,
  });

  @override
  final String email;
  @override
  final String password;
  final String firstName;
  final String lastName;
  final String username;
  final String profileImage;
  final String bio;

  @override
  bool get isComplete =>
      email != null &&
      password != null &&
      firstName != null &&
      lastName != null;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
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
      publicDen: map['private_den'] != null
          ? CentralizedDen.fromMap(map['public_den'])
          : null,
      pack: CentralizedPack.fromMap(map['pack']),
      user: UserProfile.fromMap(map['user']),
      userPerspective: CentralizedPerspective.fromMap(
        map['userPerspective'],
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
      'privateDen': privateDen.toJson(),
      'publicDen': publicDen.toJson(),
      'pack': pack.toMap(),
      'user': user.toMap(),
      'userPerspective': userPerspective.toMap(),
    };
  }

  @override
  String toString() {
    return 'UserData{privateDen: $privateDen, publicDen: $publicDen, pack: $pack, user: $user, userPerspective: $userPerspective}';
  }
}
