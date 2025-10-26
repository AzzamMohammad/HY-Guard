import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hy_guard/core/constant/file_type.dart';

class FileTypeAdapter extends TypeAdapter<FileType> {
  @override
  final int typeId = 3;

  @override
  FileType read(BinaryReader reader) {
    final index = reader.readByte();
    if (index < 0 || index >= FileType.values.length) {
      return FileType.unknown;
    }
    return FileType.values[index];
  }

  @override
  void write(BinaryWriter writer, FileType obj) {
    writer.writeByte(obj.index);
  }
}
