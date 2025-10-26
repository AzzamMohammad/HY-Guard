// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_folder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveFolderAdapter extends TypeAdapter<HiveFolder> {
  @override
  final typeId = 1;

  @override
  HiveFolder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveFolder(
      parentId: fields[0] as String,
      name: fields[1] as String,
      filesIds: (fields[3] as List).cast<String>(),
      initDate: fields[2] as DateTime,
      foldersIds: (fields[4] as List).cast<String>(),
      size: (fields[5] as num).toInt(),
      virtualPath: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveFolder obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.parentId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.initDate)
      ..writeByte(3)
      ..write(obj.filesIds)
      ..writeByte(4)
      ..write(obj.foldersIds)
      ..writeByte(5)
      ..write(obj.size)
      ..writeByte(6)
      ..write(obj.virtualPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveFolderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
