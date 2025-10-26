import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hy_guard/data/storage/models/hive_models/hive_recent_file.dart';
import '../../core/constant/hive_boxes_names.dart';

class RecentFileStorage {
  static final RecentFileStorage _instance = RecentFileStorage._internal();

  factory RecentFileStorage() => _instance;

  RecentFileStorage._internal();

  late Box<HiveRecentFile> _recentFileBox;
  bool _isOpen = false;

  Future<void> openBox() async {
    if (!_isOpen) {
      _recentFileBox = await Hive.openBox<HiveRecentFile>(
        HiveBoxesNames.recentFile,
      );
      _isOpen = true;
    }
  }

  void putNewFile(HiveRecentFile file) => _recentFileBox.add(file);

  Map<dynamic, HiveRecentFile> getRecentFilesMap() => _recentFileBox.toMap();

  Future<void> clearRecentFilesStorage() async => await _recentFileBox.clear();
}
