// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_recent_search.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveRecentSearchAdapter extends TypeAdapter<HiveRecentSearch> {
  @override
  final typeId = 4;

  @override
  HiveRecentSearch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveRecentSearch(
      query: fields[0] as String,
      filter: fields[1] as FileType?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveRecentSearch obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.query)
      ..writeByte(1)
      ..write(obj.filter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveRecentSearchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
