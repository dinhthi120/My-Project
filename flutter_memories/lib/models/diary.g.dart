// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiaryAdapter extends TypeAdapter<Diary> {
  @override
  final int typeId = 0;

  @override
  Diary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Diary(
      date: fields[0] as DateTime,
      mood: fields[1] as int,
      contentJson: fields[2] as String,
      contentPlainText: fields[3] as String,
      imgPaths: (fields[4] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Diary obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.mood)
      ..writeByte(2)
      ..write(obj.contentJson)
      ..writeByte(3)
      ..write(obj.contentPlainText)
      ..writeByte(4)
      ..write(obj.imgPaths);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
