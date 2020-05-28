// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final typeId = 1;

  @override
  UserProfile read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      address: fields[0] as String,
      name: fields[1] as String,
      bio: fields[2] as String,
      location: (fields[3] as List)?.cast<String>(),
      profilePicture: (fields[4] as List)?.cast<String>(),
      backgroundPhoto: fields[5] as String,
      verified: fields[6] as bool,
      username: fields[7] as String,
      website: (fields[8] as List)?.cast<String>(),
      gender: (fields[9] as List)?.cast<String>(),
      email: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.address)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.bio)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.profilePicture)
      ..writeByte(5)
      ..write(obj.backgroundPhoto)
      ..writeByte(6)
      ..write(obj.verified)
      ..writeByte(7)
      ..write(obj.username)
      ..writeByte(8)
      ..write(obj.website)
      ..writeByte(9)
      ..write(obj.gender)
      ..writeByte(10)
      ..write(obj.email);
  }
}
