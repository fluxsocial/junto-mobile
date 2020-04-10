// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expression.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpressionModelAdapter extends TypeAdapter<ExpressionModel> {
  @override
  final typeId = 0;

  @override
  ExpressionModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpressionModel(
      type: fields[0] as String,
      expressionData: (fields[1] as Map)?.cast<String, dynamic>(),
      channels: (fields[3] as List)?.cast<String>(),
      context: fields[2] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ExpressionModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.expressionData)
      ..writeByte(2)
      ..write(obj.context)
      ..writeByte(3)
      ..write(obj.channels);
  }
}
