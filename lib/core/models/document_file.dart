import 'package:hy_guard/core/constant/assets_names.dart';
import 'package:hy_guard/core/models/folder_content.dart';

class DocumentFile extends FolderContent {
  final String pathInStorage;

  DocumentFile({
    required super.parentId,
    required super.id,
    required super.name,
    required super.initDate,
    required super.size,
    required super.virtualPath,
    required this.pathInStorage,
  }) : super(icon: AssetsNames.textFileIcon, extension: "hyDocx");

  @override
  void open() {
    print("file $name is opened with size $size in path $pathInStorage ");
  }

  @override
  DocumentFile copyWith({
    String? parentId,
    String? id,
    String? name,
    String? virtualPath,
    DateTime? initDate,
    String? pathInStorage,
    int? size,
  }) {
    return DocumentFile(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      virtualPath: virtualPath ?? this.virtualPath,
      initDate: initDate ?? this.initDate,
      size: size ?? this.size,
      pathInStorage: pathInStorage ?? this.pathInStorage,
    );
  }
}
