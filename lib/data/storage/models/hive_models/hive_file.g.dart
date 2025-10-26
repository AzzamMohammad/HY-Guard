// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveFileAdapter extends TypeAdapter<HiveFile> {
  @override
  final typeId = 2;

  @override
  HiveFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveFile(
      parentId: fields[0] as String,
      type: fields[1] as FileType,
      name: fields[2] as String,
      initDate: fields[3] as DateTime,
      pathInStorage: fields[4] as String,
      size: (fields[5] as num).toInt(),
      virtualPath: fields[8] as String,
      iconPath: fields[6] as String?,
      extension: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveFile obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.parentId)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.initDate)
      ..writeByte(4)
      ..write(obj.pathInStorage)
      ..writeByte(5)
      ..write(obj.size)
      ..writeByte(6)
      ..write(obj.iconPath)
      ..writeByte(7)
      ..write(obj.extension)
      ..writeByte(8)
      ..write(obj.virtualPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
