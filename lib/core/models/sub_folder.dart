import 'package:hy_guard/core/constant/assets_names.dart';
import 'package:hy_guard/core/models/folder_content.dart';

class SubFolder extends FolderContent {
  SubFolder({
    required super.parentId,
    required super.id,
    required super.name,
    required super.initDate,
    required super.size,
    required super.virtualPath,
  }) : super(icon: AssetsNames.folderIcon);

  @override
  void open() {}

  @override
  SubFolder copyWith({
    String? parentId,
    String? id,
    String? name,
    String? virtualPath,
    DateTime? initDate,
    int? size,
  }) {
    return SubFolder(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      virtualPath: virtualPath ?? this.virtualPath,
      initDate: initDate ?? this.initDate,
      size: size ?? this.size,
    );
  }
}
