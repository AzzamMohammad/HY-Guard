import 'package:hive_ce/hive.dart';
import 'package:hy_guard/core/constant/hive_boxes_names.dart';

import 'models/hive_models/hive_folder.dart';

class FolderStorage {
  static final FolderStorage _instance = FolderStorage._internal();

  factory FolderStorage() => _instance;

  FolderStorage._internal();

  late Box<HiveFolder> _foldersBox;
  bool _isOpen = false;

  Future<void> openBox() async {
    if (!_isOpen) {
      _foldersBox = await Hive.openBox<HiveFolder>(HiveBoxesNames.folders);
      _isOpen = true;
    }
  }

  HiveFolder? getFolderById(String folderId) => _foldersBox.get(folderId);

  Future<void> putFolder(String folderId, HiveFolder folder) async =>
      _foldersBox.put(folderId, folder);

  Future<void> deleteFolder(String folderId) async =>
      _foldersBox.delete(folderId);

  bool folderExists(String folderId) => _foldersBox.containsKey(folderId);

  Map<dynamic, HiveFolder> getFoldersMap() => _foldersBox.toMap();
}
