import 'package:file_picker/file_picker.dart' hide FileType;
import 'package:hy_guard/core/constant/storage_type.dart';
import 'package:hy_guard/core/models/folder.dart';
import 'package:hy_guard/core/models/folder_content.dart';
import 'package:hy_guard/core/utils/either.dart';
import 'package:hy_guard/data/repositories/local_storage_repository/file_service.dart';
import 'package:hy_guard/data/repositories/local_storage_repository/folder_content_manager.dart';
import 'package:hy_guard/data/repositories/local_storage_repository/folder_service.dart';
import 'package:hy_guard/data/repositories/local_storage_repository/utils.dart';
import 'package:hy_guard/core/constant/file_type.dart';
import 'package:hy_guard/data/storage/models/hive_models/hive_recent_file.dart';

import '../../../core/utils/media_file_tipe.dart';
import '../../storage/recent_file_storage.dart';

class LocalStorageRepository {
  late FolderService _folderService;
  late FileService _fileService;
  late FolderContentManager _folderContentManager;

  LocalStorageRepository() {
    _folderContentManager = FolderContentManager();
    _folderService = FolderService();
    _fileService = FileService();
  }

  Future<Either<String, Folder>> getFolder(String folderId) async {
    try {
      Folder folder = await _folderService.openFolder(folderId);
      return Right(folder);
    } catch (error) {
      return Left(error.toString());
    }
  }

  void addFileToRecentFiles(String folderId) {
    try {
      RecentFileStorage recentFileStorage = RecentFileStorage();
      final recentFiles = recentFileStorage.getRecentFilesMap();
      for (var file in recentFiles.values) {
        if(file.fileId == folderId) {
          return;
        }
      }
      recentFileStorage.putNewFile(
        HiveRecentFile(
          fileId: folderId,
          storageType: StorageType.locale,
          lastModified: DateTime.now(),
        ),
      );
    } catch (error) {}
  }

  Future<Either<String, Folder>> createFolder(
    String folderName,
    String parentFolderId,
  ) async {
    try {
      Folder folder = await _folderService.createFolder(
        folderName,
        parentFolderId,
      );
      return Right(folder);
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, Map<String, dynamic>>> moveFolderContents(
    List<FolderContent> contents,
    String fromSourceFolderId,
    String toDestinationFolderId,
  ) async {
    try {
      // contents that have names already exist in destination folder
      List<FolderContent> unMovedFolderContents = await _folderContentManager
          .moveFolderContentsToDestinationFolder(
            contents,
            fromSourceFolderId,
            toDestinationFolderId,
          );
      Folder updatedSourceFolder = _folderService.getFolder(
        folderId: fromSourceFolderId,
      );
      Map<String, dynamic> resultMap = {
        "updated_source_folder": updatedSourceFolder,
        "unmoved_contents": unMovedFolderContents,
      };
      return Right(resultMap);
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, Map<String, dynamic>>> replaceUnmovedFolderContents(
    List<FolderContent> contents,
    String fromSourceFolderId,
    String toDestinationFolderId,
    bool isReplacingForAll,
  ) async {
    try {
      List<FolderContent> folderContentsThatNeedToBeReplaced = [];
      if (isReplacingForAll) {
        folderContentsThatNeedToBeReplaced.addAll(contents);
        contents.clear();
      } else {
        folderContentsThatNeedToBeReplaced.add(contents.first);
        contents.removeAt(0);
      }

      await _folderContentManager
          .replaceUnmovedFolderContentsAtDestinationFolder(
            folderContentsThatNeedToBeReplaced,
            fromSourceFolderId,
            toDestinationFolderId,
          );
      Folder updatedSourceFolder = _folderService.getFolder(
        folderId: fromSourceFolderId,
      );
      Map<String, dynamic> resultMap = {
        "updated_source_folder": updatedSourceFolder,
        "unmoved_contents": contents,
      };
      return Right(resultMap);
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, Map<String, dynamic>>> renameUnmovedFolderContents(
    List<FolderContent> contents,
    String fromSourceFolderId,
    String toDestinationFolderId,
    bool isRenameForAll,
  ) async {
    try {
      List<FolderContent> folderContentsThatNeedToBeRenamed = [];
      if (isRenameForAll) {
        folderContentsThatNeedToBeRenamed.addAll(contents);
        contents.clear();
      } else {
        folderContentsThatNeedToBeRenamed.add(contents.first);
        contents.removeAt(0);
      }
      await _folderContentManager
          .renameUnmovedFolderContentsAtDestinationFolder(
            folderContentsThatNeedToBeRenamed,
            fromSourceFolderId,
            toDestinationFolderId,
          );

      Folder updatedSourceFolder = _folderService.getFolder(
        folderId: fromSourceFolderId,
      );
      Map<String, dynamic> resultMap = {
        "updated_source_folder": updatedSourceFolder,
        "unmoved_contents": contents,
      };
      return Right(resultMap);
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, Map<String, dynamic>>> copyFolderContents(
    List<FolderContent> contents,
    String fromSourceFolderId,
    String toDestinationFolderId,
  ) async {
    try {
      // contents that have names already exist in destination folder
      List<FolderContent> unCopiedFolderContents = await _folderContentManager
          .copyFolderContentsToDestinationFolder(
            contents,
            toDestinationFolderId,
          );
      Folder updatedSourceFolder = _folderService.getFolder(
        folderId: fromSourceFolderId,
      );
      Map<String, dynamic> resultMap = {
        "updated_source_folder": updatedSourceFolder,
        "uncopied_contents": unCopiedFolderContents,
      };
      return Right(resultMap);
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String,  Map<String, dynamic>>> replaceUncopiedFolderContents(
    List<FolderContent> contents,
    String fromSourceFolderId,
    String toDestinationFolderId,
    bool isReplacingForAll,
  ) async {
    try {
      List<FolderContent> folderContentsThatNeedToBeReplaced = [];
      if (isReplacingForAll) {
        folderContentsThatNeedToBeReplaced.addAll(contents);
        contents.clear();
      } else {
        folderContentsThatNeedToBeReplaced.add(contents.first);
        contents.removeAt(0);
      }
      await _folderContentManager
          .replaceUncopiedFolderContentsAtDestinationFolder(
            folderContentsThatNeedToBeReplaced,
            toDestinationFolderId,
          );
      Folder updatedSourceFolder = _folderService.getFolder(
        folderId: fromSourceFolderId,
      );
      Map<String, dynamic> resultMap = {
        "updated_source_folder": updatedSourceFolder,
        "uncopied_contents": contents,
      };
      return Right(resultMap);
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String,  Map<String, dynamic>>> renameUncopiedFolderContents(
    List<FolderContent> contents,
    String fromSourceFolderId,
    String toDestinationFolderId,
    bool isRenameForAll,
  ) async {
    try {
      List<FolderContent> folderContentsThatNeedToBeRenamed = [];
      if (isRenameForAll) {
        folderContentsThatNeedToBeRenamed.addAll(contents);
        contents.clear();
      } else {
        folderContentsThatNeedToBeRenamed.add(contents.first);
        contents.removeAt(0);
      }
      await _folderContentManager
          .renameUncopiedFolderContentsAtDestinationFolder(
            folderContentsThatNeedToBeRenamed,
            fromSourceFolderId,
            toDestinationFolderId,
          );
      Folder updatedSourceFolder = _folderService.getFolder(
        folderId: fromSourceFolderId,
      );
      Map<String, dynamic> resultMap = {
        "updated_source_folder": updatedSourceFolder,
        "uncopied_contents": contents,
      };
      return Right(resultMap);
    } catch (error) {
      return Left(error.toString());
    }
  }

  Either<bool, List<FolderContent>> skipFolderContentAction(
    List<FolderContent> contents,
    bool isSkipForAll,
  ) {
    if (!isSkipForAll && contents.length > 1) {
      final List<FolderContent> unSkipFolderContents = contents;
      unSkipFolderContents.removeAt(0);
      return Right(contents);
    }
    return Left(false);
  }

  Future<Either<String, Folder>> deleteFolderContents(
    List<FolderContent> contents,
    String fromSourceFolderId,
  ) async {
    try {
      await _folderContentManager.deleteFolderContentsFromSource(
        contents,
        fromSourceFolderId,
      );
      Folder updatedSourceFolder = _folderService.getFolder(
        folderId: fromSourceFolderId,
      );
      return Right(updatedSourceFolder);
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, Folder>> renameSelectedContent(
    String newName,
    String contentId,
    String parentId,
  ) async {
    try {
      _folderContentManager.renameContent(contentId, newName);
      Folder updatedParentFolder = _folderService.getFolder(folderId: parentId);
      return Right(updatedParentFolder);
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, Folder>> savePickedFilesToStorage(
    String toFolderId,
    PlatformFile pickResult,
  ) async {
    try {
      // generate valid file name
      String newValidFileName = _folderContentManager.getValidFileName(
        toFolderId,
        pickResult.name,
        pickResult.extension,
      );
      // save a copy from file to app storage
      String newFilePath = await addFileToAppStorage(
        pickResult.path!,
        newValidFileName,
      );
      // get file type
      FileType fileType = getFileType(pickResult.extension);
      // get file icon
      String? fileIcon = await generateFileIcon(
        newFilePath,
        fileType,
        newValidFileName,
      );
      // get size
      int fileSize = pickResult.size;
      // save file to locale storage
      await _folderContentManager.addFile(
        toFolderId,
        newFilePath,
        fileType,
        fileIcon,
        fileSize,
        pickResult.extension,
        newValidFileName,
      );
      // get parent folder instance
      Folder updatedParentFolder = _folderService.getFolder(
        folderId: toFolderId,
      );
      return Right(updatedParentFolder);
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, List<FolderContent>>> searchForContent(
    String query,
    FileType? type,
  ) async {
    try {
      await openHiveBoxes();
      List<FolderContent> result = [];
      List<FolderContent> files = _fileService.search(query, type);
      result.addAll(files);
      if (type == null) {
        List<FolderContent> folders = _folderService.search(query);
        result.addAll(folders);
      }
      return Right(result);
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, List<FolderContent>>> recentFileToContent(
    List<String> contentIds,
  ) async{
    try {
      await openHiveBoxes();
      List<FolderContent> recentContent = [];
      recentContent = _fileService.hiveFilesIdsToContents(contentIds);
      return Right(recentContent);
    } catch (error) {
      return Left(error.toString());
    }
  }
}
