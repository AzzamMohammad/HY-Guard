import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hy_guard/core/constant/file_type.dart';

part 'hive_file.g.dart';

/// Define this class as a Hive type with a unique typeId
@HiveType(typeId: 2)
class HiveFile {
  /// The ID of the parent folder (Parent Node).
  @HiveField(0)
  final String parentId;

  /// type of file object
  @HiveField(1)
  final FileType type;

  /// File name
  @HiveField(2)
  String name;

  /// Creation date
  @HiveField(3)
  final DateTime initDate;

  /// Path of file in app storage
  @HiveField(4)
  final String pathInStorage;

  /// size of folder
  @HiveField(5)
  final int size;

  /// icon
  @HiveField(6)
  final String? iconPath;

  /// file extension
  @HiveField(7)
  final String? extension;

  /// logical path of the file within the folder tree
  @HiveField(8)
  String virtualPath;

  HiveFile({
    required this.parentId,
    required this.type,
    required this.name,
    required this.initDate,
    required this.pathInStorage,
    required this.size,
    required this.virtualPath,
    this.iconPath,
    this.extension,
  });

  HiveFile copyWith({
    String? parentId,
    FileType? type,
    String? name,
    DateTime? initDate,
    String? pathInStorage,
    int? size,
    String? extension,
    String? iconPath,
    String? virtualPath,
  }) {
    return HiveFile(
      parentId: parentId ?? this.parentId,
      type: type ?? this.type,
      name: name ?? this.name,
      initDate: initDate ?? this.initDate,
      pathInStorage: pathInStorage ?? this.pathInStorage,
      size: size ?? this.size,
      extension: extension ?? this.extension,
      iconPath: iconPath ?? this.iconPath,
      virtualPath: virtualPath ?? this.virtualPath,
    );
  }
}
