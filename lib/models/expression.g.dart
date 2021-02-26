// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expression.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AudioFormExpressionAdapter extends TypeAdapter<AudioFormExpression> {
  @override
  final typeId = 5;

  @override
  AudioFormExpression read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AudioFormExpression(
      title: fields[0] as String,
      photo: fields[1] as String,
      audio: fields[2] as String,
      gradient: (fields[3] as List)?.cast<String>(),
      caption: fields[4] as String,
      thumbnail300: fields[5] as String,
      thumbnail600: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AudioFormExpression obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.photo)
      ..writeByte(2)
      ..write(obj.audio)
      ..writeByte(3)
      ..write(obj.gradient)
      ..writeByte(4)
      ..write(obj.caption)
      ..writeByte(5)
      ..write(obj.thumbnail300)
      ..writeByte(6)
      ..write(obj.thumbnail600);
  }
}

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

class LinkFormExpressionAdapter extends TypeAdapter<LinkFormExpression> {
  @override
  final typeId = 8;

  @override
  LinkFormExpression read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LinkFormExpression(
      title: fields[0] as String,
      caption: fields[1] as String,
      url: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LinkFormExpression obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.caption)
      ..writeByte(2)
      ..write(obj.url);
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
      thumbnail300: fields[2] as String,
      thumbnail600: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PhotoFormExpression obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.caption)
      ..writeByte(2)
      ..write(obj.thumbnail300)
      ..writeByte(3)
      ..write(obj.thumbnail600);
  }
}

class EventFormExpressionAdapter extends TypeAdapter<EventFormExpression> {
  @override
  final typeId = 9;

  @override
  EventFormExpression read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventFormExpression(
      title: fields[0] as String,
      description: fields[1] as String,
      photo: fields[2] as String,
      location: fields[3] as String,
      startTime: fields[4] as String,
      endTime: fields[5] as String,
      facilitators: (fields[6] as List)?.cast<String>(),
      members: (fields[7] as List)?.cast<String>(),
      thumbnail300: fields[8] as String,
      thumbnail600: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EventFormExpression obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.photo)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.endTime)
      ..writeByte(6)
      ..write(obj.facilitators)
      ..writeByte(7)
      ..write(obj.members)
      ..writeByte(8)
      ..write(obj.thumbnail300)
      ..writeByte(9)
      ..write(obj.thumbnail600);
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
      createdAt: fields[11] as DateTime,
      numberResonations: fields[3] as int,
      creator: fields[10] as UserProfile,
      context: fields[9] as String,
      privacy: fields[7] as String,
      channels: (fields[8] as List)?.cast<dynamic>(),
      numberComments: fields[4] as int,
      comments: fields[6] as dynamic,
      resonations: fields[5] as dynamic,
      commentThread: (fields[12] as List)?.cast<ExpressionResponse>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExpressionResponse obj) {
    writer
      ..writeByte(13)
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
      ..write(obj.creator)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.commentThread);
  }
}
