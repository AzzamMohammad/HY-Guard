import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../../../core/constant/storage_type.dart';

class StorageTypeAdapter extends TypeAdapter<StorageType> {
  @override
  final int typeId = 6;

  @override
  StorageType read(BinaryReader reader) {
    final index = reader.readByte();
    if (index < 0 || index >= StorageType.values.length) {
      return StorageType.locale;
    }
    return StorageType.values[index];
  }

  @override
  void write(BinaryWriter writer, StorageType obj) {
    writer.writeByte(obj.index);
  }
}
