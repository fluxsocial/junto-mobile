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
      Pack(
        'Wags',
        'Riley Wagner',
        'assets/images/junto-mobile__riley.png',
      ),
      Pack(
        'Kevin-san',
        'Kevin Yang',
        'assets/images/junto-mobile__kevin.png',
      ),
      Pack(
        'Ecstatic Dancers',
        'Josh Parkin',
        'assets/images/junto-mobile__josh.png',
      ),      
      Pack(
        'HeruPandie',
        'Dora Czovek',
        'assets/images/junto-mobile__dora.png',
      ),
      Pack(
        'ByDrea',
        'Drea Bennett',
        'assets/images/junto-mobile__drea.png',
      ),
      Pack(
        'Cats',
        'Yaz Owainati',
        'assets/images/junto-mobile__yaz.png',
      ),
      Pack(
        'FlatToppers',
        'Ekene Nkem-Mmekam',
        'assets/images/junto-mobile__ekene.png',
      ),
      Pack(
        'Levels',
        'David Wu',
        'assets/images/junto-mobile__david.png',
      ),
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
      name: map['entry']['name'] as String,
      ownerAddress: map['entry']['ownerAddress'] as String,
      privacy: map['entry']['privacy'] as String,
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
        'ownerAddress': ownerAddress,
        'privacy': privacy,
      }
    };
  }
}
