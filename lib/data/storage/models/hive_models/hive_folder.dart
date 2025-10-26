import 'package:hive_ce_flutter/hive_flutter.dart';

part 'hive_folder.g.dart';

// Define this class as a Hive type with a unique typeId
@HiveType(typeId: 1)
class HiveFolder {
  // The ID of the parent folder (Parent Node).
  @HiveField(0)
  final String parentId;

  // The folder’s name
  @HiveField(1)
  String name;

  // The date/time when this folder was created
  @HiveField(2)
  final DateTime initDate;

  // List of IDs for files inside this folder (IDs from the files Box)
  @HiveField(3)
  final List<String> filesIds;

  // List of IDs for subfolders (IDs from the folders Box)
  @HiveField(4)
  final List<String> foldersIds;

  // total sizes of folder content
  @HiveField(5)
  int size;

  /// logical path of the file within the folder tree
  @HiveField(6)
  String virtualPath;

  HiveFolder({
    required this.parentId,
    required this.name,
    required this.filesIds,
    required this.initDate,
    required this.foldersIds,
    required this.size,
    required this.virtualPath,
  });

  HiveFolder copyWith({
    String? parentId,
    String? name,
    DateTime? initDate,
    List<String>? filesIds,
    List<String>? foldersIds,
    int? size,
    String? virtualPath,
  }) {
    return HiveFolder(
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      initDate: initDate ?? this.initDate,
      filesIds: filesIds ?? this.filesIds,
      foldersIds: foldersIds ?? this.foldersIds,
      size: size ?? this.size,
      virtualPath: virtualPath ?? this.virtualPath,
    );
  }
}
