// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 0;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book(
      title: fields[0] as String,
      author: fields[1] as String,
      category: fields[2],
      tags: (fields[3] as List<String>?),
      coverImagePath: fields[4] as String?,
      status: fields[5] as BookStatus,
      note: fields[6] as String,
      rate: fields[7] as int?,
      saveDate: fields[8] as DateTime,
      readingDate: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.tags)
      ..writeByte(4)
      ..write(obj.coverImagePath)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.note)
      ..writeByte(7)
      ..write(obj.rate)
      ..writeByte(8)
      ..write(obj.saveDate)
      ..writeByte(9)
      ..write(obj.readingDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}