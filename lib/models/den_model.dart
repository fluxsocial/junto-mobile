import 'package:meta/meta.dart';

class Den {
  const Den({
    @required this.address,
    @required this.entry,
    @required this.denName,
    @required this.privacy,
    @required this.channelType,
  });
  factory Den.fromMap(Map<String, dynamic> map) {
    return Den(
      address: map['address'] as String,
      entry: map['entry'] as Map<String, dynamic>,
      denName: map['denName'] as String,
      privacy: map['privacy'] as String,
      channelType: map['channelType'] as String,
    );
  }

  /// Address of the Den
  final String address;

  /// Entry containing the `parent` key
  final Map<String, dynamic> entry;

  /// Name of the given Den
  final String denName;

  /// Privacy setting of the den. Either `shared`, `private` or `public`.
  final String privacy;

  /// Indicates the type of object, in this case it will be `Den`.
  final String channelType;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'entry': entry,
      'denName': denName,
      'privacy': privacy,
      'channelType': channelType,
    };
  }
}
