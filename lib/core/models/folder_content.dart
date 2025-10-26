abstract class FolderContent {
  final String parentId;
  final String id;
  String name;
  final DateTime initDate;
  final String virtualPath;
  int size;
  final String? icon;
  final String? extension;

  FolderContent({
    required this.parentId,
    required this.id,
    required this.name,
    required this.initDate,
    required this.size,
    required this.virtualPath,
    this.icon,
    this.extension,
  });

  void open();

  FolderContent copyWith();

  @override
  String toString() {
    return 'FolderContent(parentId: $parentId, id: $id, name: $name, initDate: $initDate, size: $size, icon: $icon)';
  }
}
