import 'package:meta/meta.dart';

class Den {
  Den({
    @required this.address,
    @required this.name,
    @required this.creator,
    @required this.privacy,
    @required this.isDefault,
  });

  factory Den.fromMap(Map<String, dynamic> map) {
    return Den(
      address: map['address'] ?? '',
      name: map['name'] as String,
      creator: map['creator'] as String,
      privacy: map['privacy'] as String,
      isDefault: map['is_default'] as bool,
    );
  }

  final String address;
  final String name;
  final String creator;
  final String privacy;
  final bool isDefault;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'address': address,
      'name': name,
      'creator': creator,
      'privacy': privacy,
      'is_default': isDefault,
    };
  }
}
