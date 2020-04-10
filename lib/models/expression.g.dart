// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expression.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LongFormExpressionAdapter extends TypeAdapter<LongFormExpression> {
  @override
  final typeId = 4;

  @override
  LongFormExpression read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LongFormExpression(
      title: fields[0] as String,
      body: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LongFormExpression obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.body);
  }
}

class ShortFormExpressionAdapter extends TypeAdapter<ShortFormExpression> {
  @override
  final typeId = 3;

  @override
  ShortFormExpression read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShortFormExpression(
      background: (fields[0] as List)?.cast<dynamic>(),
      body: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShortFormExpression obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.background)
      ..writeByte(1)
      ..write(obj.body);
  }
}

class PhotoFormExpressionAdapter extends TypeAdapter<PhotoFormExpression> {
  @override
  final typeId = 2;

  @override
  PhotoFormExpression read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PhotoFormExpression(
      image: fields[0] as String,
      caption: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PhotoFormExpression obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.caption);
  }
}

class ExpressionResponseAdapter extends TypeAdapter<ExpressionResponse> {
  @override
  final typeId = 0;

  @override
  ExpressionResponse read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpressionResponse(
      address: fields[0] as String,
      type: fields[1] as String,
      expressionData: fields[2] as dynamic,
      numberResonations: fields[3] as int,
      creator: fields[10] as UserProfile,
      context: fields[9] as String,
      privacy: fields[7] as String,
      channels: (fields[8] as List)?.cast<dynamic>(),
      numberComments: fields[4] as int,
      comments: fields[6] as dynamic,
      resonations: fields[5] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ExpressionResponse obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.address)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.expressionData)
      ..writeByte(3)
      ..write(obj.numberResonations)
      ..writeByte(4)
      ..write(obj.numberComments)
      ..writeByte(5)
      ..write(obj.resonations)
      ..writeByte(6)
      ..write(obj.comments)
      ..writeByte(7)
      ..write(obj.privacy)
      ..writeByte(8)
      ..write(obj.channels)
      ..writeByte(9)
      ..write(obj.context)
      ..writeByte(10)
      ..write(obj.creator);
  }
}
