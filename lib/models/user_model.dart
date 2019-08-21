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
