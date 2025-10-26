import 'package:hy_guard/core/models/recent_file.dart';
import 'package:hy_guard/data/storage/recent_file_storage.dart';

import '../../core/utils/either.dart';

class RecentFileRepository {
  late final RecentFileStorage _recentFileStorage;

  RecentFileRepository() {
    _recentFileStorage = RecentFileStorage();
  }

  Future<Either<String, List<RecentFile>>> getRecentFiles() async {
    try {
      await _recentFileStorage.openBox();
      List<RecentFile> recentFiles = [];
    for (var file in _recentFileStorage.getRecentFilesMap().values) {
      RecentFile recentFile = RecentFile(
          id: file.fileId,
          storageType: file.storageType,
          lastModified: file.lastModified,
        );
        recentFiles.add(recentFile);
      }
      return Right(recentFiles);
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, bool>> clearRecentFilesList() async {
    try {
      await _recentFileStorage.clearRecentFilesStorage();
      return Right(true);
    } catch (error) {
      return Left(error.toString());
    }
  }
}
