import 'package:hy_guard/core/models/folder_content.dart';

class Folder {
  final String id;
  final String parentId;
  final String name;
  final DateTime initDate;
  final List<FolderContent> contents;
  int size;

  Folder({
    required this.id,
    required this.parentId,
    required this.name,
    required this.initDate,
    required this.contents,
    required this.size,
  });

  @override
  String toString() {
    return 'Folder(id: $id, parentId: $parentId, name: $name, initDate: $initDate, size: $size, contents: $contents)';
  }
}
