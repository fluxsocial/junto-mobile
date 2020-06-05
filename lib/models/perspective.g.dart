// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perspective.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PerspectiveModelAdapter extends TypeAdapter<PerspectiveModel> {
  @override
  final typeId = 7;

  @override
  PerspectiveModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PerspectiveModel(
      address: fields[0] as String,
      name: fields[1] as String,
      creator: fields[2] as String,
      createdAt: fields[3] as DateTime,
      isDefault: fields[4] as bool,
      userCount: fields[5] as int,
      users: (fields[6] as List)?.cast<UserProfile>(),
      about: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PerspectiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.address)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.creator)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.isDefault)
      ..writeByte(5)
      ..write(obj.userCount)
      ..writeByte(6)
      ..write(obj.users)
      ..writeByte(7)
      ..write(obj.about);
  }
}
