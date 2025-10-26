import 'package:hy_guard/core/models/folder_content.dart';
import 'package:open_file/open_file.dart';

class ExternalFile extends FolderContent {
  final String pathInStorage;

  ExternalFile({
    required super.parentId,
    required super.id,
    required super.name,
    required super.initDate,
    required super.size,
    required super.virtualPath,
    super.icon,
    required this.pathInStorage,
    super.extension,
  });

  @override
  ExternalFile copyWith({
    String? parentId,
    String? id,
    String? name,
    DateTime? initDate,
    String? pathInStorage,
    int? size,
    String? icon,
    String? virtualPath,
  }) {
    return ExternalFile(
      parentId: parentId ?? this.parentId,
      id: id ?? this.id,
      name: name ?? this.name,
      initDate: initDate ?? this.initDate,
      size: size ?? this.size,
      icon: icon ?? this.icon,
      pathInStorage: pathInStorage ?? this.pathInStorage,
      virtualPath: virtualPath ?? this.virtualPath,
    );
  }

  @override
  void open() {
    OpenFile.open(pathInStorage);
  }
}
