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
  });

  /// Converts the information contained in this class to a map
  factory UserProfile.fromMap(Map<String, dynamic> json) {
    return UserProfile(
      address: json['entry']['address'],
      parent: json['entry']['parent'],
      firstName: json['entry']['first_name'],
      lastName: json['entry']['last_name'],
      bio: json['entry']['bio'],
      profilePicture: json['entry']['profile_picture'],
      verified: json['entry']['verified'],
    );
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

  /// Converts the class to a map
  Map<String, dynamic> toMap() => <String, dynamic>{
        'address': address,
        'entry': <String, dynamic>{
          'parent': parent,
          'first_name': firstName,
          'last_name': lastName,
          'bio': bio,
          'profile_picture': profilePicture,
          'verified': verified,
        },
      };
}

/// The username of the user.
class Username {
  Username({
    this.address,
    this.username,
  });

  /// Creates an [Username] from the map data.
  factory Username.fromMap(Map<String, dynamic> json) => Username(
        address: json['address'],
        username: json['entry']['username'],
      );

  /// Location
  final String address;

  /// Username of the user
  final String username;

  /// Converts the object to a map
  Map<String, dynamic> toMap() => <String, dynamic>{
        'address': address,
        'entry': <String, String>{
          'username': username,
        },
      };
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
    this.bio,
    this.profileImage,
    this.username,
  });

  @override
  final String email;
  @override
  final String password;
  final String firstName;
  final String lastName;
  final String profileImage;
  final String bio;
  final String username;

  @override
  bool get isComplete => email != null && password != null && firstName != null && lastName != null;

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
