// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_recent_file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveRecentFileAdapter extends TypeAdapter<HiveRecentFile> {
  @override
  final typeId = 5;

  @override
  HiveRecentFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveRecentFile(
      fileId: fields[0] as String,
      storageType: fields[1] as StorageType,
      lastModified: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HiveRecentFile obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.fileId)
      ..writeByte(1)
      ..write(obj.storageType)
      ..writeByte(2)
      ..write(obj.lastModified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveRecentFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
