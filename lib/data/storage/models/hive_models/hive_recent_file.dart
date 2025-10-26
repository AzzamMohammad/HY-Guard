import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hy_guard/core/constant/storage_type.dart';

part 'hive_recent_file.g.dart';

@HiveType(typeId: 5)
class HiveRecentFile {
  /// The ID of the file
  @HiveField(0)
  final String fileId;

  /// storage that store the file
  @HiveField(1)
  final StorageType storageType;

  /// last modified time
  @HiveField(2)
  final DateTime lastModified;

  HiveRecentFile({
    required this.fileId,
    required this.storageType,
    required this.lastModified,
  });
}
