import 'package:junto_beta_mobile/models/den_model.dart';
import 'package:junto_beta_mobile/models/pack.dart';
import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:meta/meta.dart';

/// Generates a stripped down version of [UserProfile].
/// Mostly used for overviews and user tiles.
class SlimUserResponse {
  const SlimUserResponse({
    @required this.name,
    @required this.username,
    @required this.address,
  });

  factory SlimUserResponse.fromMap(Map<String, dynamic> map) {
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

  Map<String, dynamic> toMap() {
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
      location:
          map['location'] != null ? List<String>.from(map['location']) : null,
      profilePicture: map['profile_picture'] != null
          ? List<String>.from(map['profile_picture'])
          : null,
      verified: map['verified'] as bool,
      username: map['username'] as String,
      website:
          map['website'] != null ? List<String>.from(map['website']) : null,
      gender: map['gender'] != null ? List<String>.from(map['gender']) : null,
    );
  }

  /// User address
  final String address;

  ///  Name of the author
  final String name;

  /// Author's biography
  final String bio;

  /// Author's location
  final List<String> location;

  /// Url of the author's profile image
  final List<String> profilePicture;

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
    return 'UserProfile{'
        ' address: $address,'
        ' name: $name,'
        ' bio: $bio,'
        ' location: $location,'
        ' profilePicture: $profilePicture,'
        ' verified: $verified,'
        ' username: $username,'
        ' website: $website,'
        ' gender: $gender,'
        '}';
  }

  UserProfile copyWith({
    String address,
    String parent,
    String name,
    String bio,
    List<String> location,
    List<String> profilePicture,
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

/// Details used during user authentication.
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
  UserAuthRegistrationDetails(
      {@required this.email,
      @required this.password,
      @required this.name,
      @required this.username,
      @required this.bio,
      @required this.location,
      @required this.profileImage,
      @required this.gender,
      @required this.website,
      @required this.verificationCode});

  @override
  final String email;
  @override
  final String password;
  final String name;
  final String username;
  final String bio;
  final List<String> location;
  final List<String> profileImage;
  final List<String> gender;
  final List<String> website;
  final int verificationCode;

  @override
  bool get isComplete => email != null && password != null && name != null;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'name': name,
      'bio': bio,
      'profileImage': profileImage,
      'gender': gender,
      'website': website,
      'location': location
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
      privateDen:
          map['private_den'] != null ? Den.fromMap(map['private_den']) : null,
      publicDen:
          map['public_den'] != null ? Den.fromMap(map['public_den']) : null,
      pack: CentralizedPack.fromMap(map['pack']),
      user: UserProfile.fromMap(map['user']),
      userPerspective: PerspectiveModel.fromMap(
        map['user_perspective'],
      ),
      connectionPerspective: PerspectiveModel.fromMap(
        map['connection_perspective'],
      ),
    );
  }

  final Den privateDen;
  final Den publicDen;
  final CentralizedPack pack;
  final UserProfile user;
  final PerspectiveModel userPerspective;
  final PerspectiveModel connectionPerspective;

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
