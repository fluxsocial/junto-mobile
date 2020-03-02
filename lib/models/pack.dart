import 'package:junto_beta_mobile/utils/utils.dart' show RFC3339;
import 'package:meta/meta.dart';

class Pack {
  Pack(
    this.packTitle,
    this.packUser,
    this.packImage,
  );

  final String packTitle;
  final String packUser;
  final String packImage;

  static List<Pack> fetchAll() {
    return <Pack>[

    ];
  }
}

/// Object representing the response sent back from the server.
class PackResponse {
  PackResponse({
    @required this.address,
    @required this.name,
    @required this.ownerAddress,
    @required this.privacy,
  });

  /// Creates a [PackResponse] from the given map.
  factory PackResponse.fromMap(Map<String, dynamic> map) {
    return PackResponse(
      address: map['address'] as String,
      name: map['name'] as String,
      ownerAddress: map['ownerAddress'] as String,
      privacy: map['privacy'] as String,
    );
  }

  /// Address of the pack.
  final String address;

  /// Name of the pack.
  final String name;

  /// Address of the pack owner
  final String ownerAddress;

  /// Privacy setting of the pack.
  final String privacy;

  /// Converts the object to a map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'entry': <String, String>{
        'name': name,
        'owner_address': ownerAddress,
        'privacy': privacy,
      }
    };
  }
} 

class CentralizedPack with RFC3339 {
  CentralizedPack({
    @required this.address,
    @required this.name,
    @required this.creator,
    @required this.createdAt,
    @required this.privacy,
    @required this.isDefault,
  });

  factory CentralizedPack.fromMap(Map<String, dynamic> map) {
    return CentralizedPack(
      address: map['address'] as String,
      name: map['name'] as String,
      creator: map['creator'] as String,
      createdAt: RFC3339.parseRfc3339(map['created_at']),
      privacy: map['privacy'] as String,
      isDefault: map['is_default'] as bool,
    );
  }

  final String address;
  final String name;
  final String creator;
  final DateTime createdAt;
  final String privacy;
  final bool isDefault;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'name': name,
      'creator': creator,
      'created_at': createdAt?.toIso8601String(),
      'privacy': privacy,
      'is_default': isDefault,
    };
  }
}
