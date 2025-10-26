import 'package:hive_ce/hive.dart';
import 'package:hy_guard/core/constant/hive_boxes_names.dart';
import 'models/hive_models/hive_file.dart';

class FileStorage {
  static final FileStorage _instance = FileStorage._internal();

  factory FileStorage() => _instance;

  FileStorage._internal();

  late Box<HiveFile> _filesBox;
  bool _isOpen = false;

  Future<void> openBox() async {
    if (!_isOpen) {
      _filesBox = await Hive.openBox<HiveFile>(HiveBoxesNames.files);
      _isOpen = true;
    }
  }

  HiveFile? getFileById(String fileId) => _filesBox.get(fileId);

  Future<void> putFile(String fileId, HiveFile file) async =>
      await _filesBox.put(fileId, file);

  Future<void> deleteFile(String fileId) async =>
      await _filesBox.delete(fileId);

  bool fileExists(String fileId) => _filesBox.containsKey(fileId);

  Map<dynamic, HiveFile> getFilesMap() => _filesBox.toMap();
}
