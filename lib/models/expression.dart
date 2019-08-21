/// This class parses the raw json returned from the HOLOCHAIN endpoint.
/// It looks for the `OK` key from the response then parses the list of
/// [Expression].
class ExpressionResult {
  const ExpressionResult({
    this.result,
  });

  /// Creates an [ExpressionResult] from the given `Map`
  factory ExpressionResult.fromMap(Map<String, dynamic> json) =>
      ExpressionResult(
        result: List<Expression>.from(
          json['Ok'].map(
            (Map<String, dynamic> x) => Expression.fromMap(x),
          ),
        ),
      );

  /// List of [Expression]s returned from the HOLOCHAIN endpoint.
  final List<Expression> result;

  /// Converts the current class back to a map.
  Map<String, dynamic> toMap() => <String, dynamic>{
        'Ok': List<Expression>.from(
          result.map(
            (Expression expression) => expression.toMap(),
          ),
        ),
      };
}

/// Expressions are at the center of Junto. Users can choose form Longform,
/// shortform and media.
class Expression {
  Expression({
    this.expression,
    this.subExpressions,
    this.authorUsername,
    this.authorProfile,
    this.resonations,
    this.timestamp,
    this.channels,
  });

  /// Creates an [Expression] from the given map
  factory Expression.fromMap(Map<String, dynamic> json) {
    return Expression(
      expression: ExpressionContent.fromMap(
        json['expression'],
      ),
      subExpressions: List<Expression>.from(
        json['sub_expressions'].map(
          (Map<String, dynamic> expression) => Expression.fromMap(expression),
        ),
      ),
      authorUsername: AuthorUsername.fromMap(
        json['author_username'],
      ),
      authorProfile: AuthorProfile.fromMap(
        json['author_profile'],
      ),
      resonations: List<dynamic>.from(
        json['resonations'].map((dynamic resonations) => resonations),
      ),
      timestamp: json['timestamp'],
      channels: List<Channel>.from(
        json['channels'].map(
          (dynamic channel) => Channel.fromMap(channel),
        ),
      ),
    );
  }

  final ExpressionContent expression;

  /// List of expressions associated with the given `Expression`
  final List<Expression> subExpressions;

  /// This field contains the author's address and entry (username)
  final AuthorUsername authorUsername;

  /// Contains the address and profile information associated with the author.
  final AuthorProfile authorProfile;

  //TODO(Nash):  Speak to Eric regarding the content of resonations
  final List<dynamic> resonations;

  /// String containing the date
  final String timestamp;

  /// The channel where the expression was posted
  final List<Channel> channels;

  /// Converts the given expression to Map
  Map<String, dynamic> toMap() => <String, dynamic>{
        'expression': expression.toMap(),
        'sub_expressions': List<dynamic>.from(
          subExpressions.map(
            (Expression subExpression) => subExpression.toMap(),
          ),
        ),
        'author_username': authorUsername.toMap(),
        'author_profile': authorProfile.toMap(),
        'resonations': List<dynamic>.from(
          resonations.map((dynamic resonations) => resonations),
        ),
        'timestamp': timestamp,
        'channels': List<dynamic>.from(
          channels.map(
            (Channel channel) => channel.toMap(),
          ),
        ),
      };
}

/// Class used to store the profile information of an [Expression]'s author.
/// Contains the [address], [parent], [firstName], [lastName], [bio],
/// [profilePicture], [verified].
class AuthorProfile {
  AuthorProfile({
    this.address,
    this.parent,
    this.firstName,
    this.lastName,
    this.bio,
    this.profilePicture,
    this.verified,
  });

  /// Converts the information contained in this class to a map
  factory AuthorProfile.fromMap(Map<String, dynamic> json) {
    return AuthorProfile(
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

/// The username of the author.
class AuthorUsername {
  AuthorUsername({
    this.address,
    this.username,
  });

  /// Creates an [AuthorUsername] from the map data.
  factory AuthorUsername.fromMap(Map<String, dynamic> json) => AuthorUsername(
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

class Channel {
  Channel({
    this.address,
    this.value,
    this.attributeType,
  });

  factory Channel.fromMap(Map<String, dynamic> json) => Channel(
        address: json['address'],
        attributeType: json['entry']['attribute_type'],
        value: json['entry']['value'],
      );

  /// Location
  final String address;

  /// Channel where the `Expression` was posted
  final String value;

  final String attributeType;

  /// Converts the object to a map
  Map<String, dynamic> toMap() => <String, dynamic>{
        'address': address,
        'entry': <String, String>{
          'value': value,
          'attribute_type': attributeType,
        },
      };
}

/// Contains the type of expression along with the content of the expression.
/// Fields include [title] and [body].
class ExpressionContent {
  ExpressionContent({
    this.address,
    this.expressionContent,
    this.expressionType,
  });

  factory ExpressionContent.fromMap(Map<String, dynamic> json) {
    return ExpressionContent(
      address: json['address'],
      expressionType: json['entry']['expression_type'],
      expressionContent: json['entry']['expression'],
    );
  }

  /// Location
  String address;

  /// The type of [Expression]. Longform or shortform
  final String expressionType;

  /// Contains the content of the expression. Varies depending on
  /// [expressionType]
  final Map<String, dynamic> expressionContent;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'entry': <String, dynamic>{
        'expression_type': expressionType,
        'expression': expressionContent,
      },
    };
  }
}
