import 'package:hy_guard/core/models/folder_content.dart';
import 'package:hy_guard/data/repositories/local_storage_repository/file_service.dart';
import 'package:hy_guard/data/repositories/local_storage_repository/folder_service.dart';
import '../../../core/constant/file_type.dart';
import '../../../core/models/sub_folder.dart';
import '../../storage/folder_storage.dart';
import '../../storage/models/hive_models/hive_folder.dart';

class FolderContentManager {
  late FileService _fileService;
  late FolderService _folderService;

  late FolderStorage _folderStorage;

  FolderContentManager() {
    _folderService = FolderService();
    _fileService = FileService();
    _folderStorage = FolderStorage();
  }

  /// Tries to move a list of contents (files/folders)
  /// from a source folder to a destination folder.
  /// Returns a list of contents that could not be moved (due to name conflict).
  Future<List<FolderContent>> moveFolderContentsToDestinationFolder(
    List<FolderContent> contents,
    String fromSourceFolderId,
    String toDestinationFolderId,
  ) async {
    // Get destination folder from Hive
    final destinationHiveFolder = _folderStorage.getFolderById(
      toDestinationFolderId,
    );
    // If needed, also get the source folder
    final sourceHiveFolder = _folderStorage.getFolderById(fromSourceFolderId);
    final List<FolderContent> unMovedFolderContents = [];

    // Loop through each content item and try to move it
    for (final content in contents) {
      // Check if a folder/file with the same name already exists in destination
      bool isExist = _folderService.containNameISExists(
        content.name,
        destinationHiveFolder!,
      );
      if (isExist) {
        unMovedFolderContents.add(content); // cannot move this content
        continue;
      }
      // Move the content to destination (and remove from source if required)
      _moveContent(content, destinationHiveFolder, sourceHiveFolder!);
    }
    // Save changes to Hive
    await _folderStorage.putFolder(
      toDestinationFolderId,
      destinationHiveFolder!,
    );
    await _folderStorage.putFolder(fromSourceFolderId, sourceHiveFolder!);
    return unMovedFolderContents;
  }

  /// Replace list of unmoved contents (files/folders)
  /// from a source folder to a destination folder.
  Future<void> replaceUnmovedFolderContentsAtDestinationFolder(
    List<FolderContent> contents,
    String fromSourceFolderId,
    String toDestinationFolderId,
  ) async {
    // Get destination folder from Hive
    final destinationHiveFolder = _folderStorage.getFolderById(
      toDestinationFolderId,
    );

    // If needed, also get the source folder
    final sourceHiveFolder = _folderStorage.getFolderById(fromSourceFolderId);

    // Loop through each content item and try to move it
    for (final content in contents) {
      String destinationContentId = _folderService.getContentId(
        content.name,
        destinationHiveFolder!,
      );
      await _deleteContent(destinationContentId, destinationHiveFolder);
      // Move the content to destination (and remove from source if required)
      _moveContent(content, destinationHiveFolder, sourceHiveFolder!);
    }

    // Save changes to Hive
    await _folderStorage.putFolder(
      toDestinationFolderId,
      destinationHiveFolder!,
    );
    await _folderStorage.putFolder(fromSourceFolderId, sourceHiveFolder!);
  }

  /// Rename list of unmoved contents (files/folders)
  /// from a source folder to a destination folder.
  Future<void> renameUnmovedFolderContentsAtDestinationFolder(
    List<FolderContent> contents,
    String fromSourceFolderId,
    String toDestinationFolderId,
  ) async {
    // Get destination folder from Hive
    final destinationHiveFolder = _folderStorage.getFolderById(
      toDestinationFolderId,
    );

    // If needed, also get the source folder
    final sourceHiveFolder = _folderStorage.getFolderById(fromSourceFolderId);

    // Loop through each content item and try to move it
    for (final content in contents) {
      // rename folder/file with a new one that does not exist among the destination folder contents
      String newValidName = _folderService.generateNewContentName(
        destination: destinationHiveFolder!,
        contentName: content.name,
        extension: content.extension,
      );
      //rename folder/file with the new one
      _renameContent(content.id, newValidName);
      // Move the content to destination (and remove from source if required)
      _moveContent(content, destinationHiveFolder, sourceHiveFolder!);
    }

    // Save changes to Hive
    await _folderStorage.putFolder(
      toDestinationFolderId,
      destinationHiveFolder!,
    );
    await _folderStorage.putFolder(fromSourceFolderId, sourceHiveFolder!);
  }

  /// Tries to copy a list of contents (files/folders)
  /// from a source folder to a destination folder.
  /// Returns a list of contents that could not be copied (due to name conflict).
  Future<List<FolderContent>> copyFolderContentsToDestinationFolder(
    List<FolderContent> contents,
    String toDestinationFolderId,
  ) async {
    // Get destination folder from Hive
    final destinationHiveFolder = _folderStorage.getFolderById(
      toDestinationFolderId,
    );

    final List<FolderContent> unCopiedFolderContents = [];

    // Loop through each content item and try to move it
    for (final content in contents) {
      // Check if a folder/file with the same name already exists in destination
      if (_folderService.containNameISExists(
        content.name,
        destinationHiveFolder!,
      )) {
        unCopiedFolderContents.add(content); // cannot copy this content
        continue;
      }
      // Copy the content to destination
      await _copyContent(
        content.id,
        toDestinationFolderId,
        destinationHiveFolder,
      );
    }
    // Save changes to Hive
    await _folderStorage.putFolder(
      toDestinationFolderId,
      destinationHiveFolder!,
    );
    return unCopiedFolderContents;
  }

  /// Replace list of uncopied contents  (files/folders)
  /// from a source folder to a destination folder.
  Future<void> replaceUncopiedFolderContentsAtDestinationFolder(
    List<FolderContent> contents,
    String toDestinationFolderId,
  ) async {
    // Get destination folder from Hive
    final destinationHiveFolder = _folderStorage.getFolderById(
      toDestinationFolderId,
    );
    // Loop through each content item and try to move it
    for (final content in contents) {
      String destinationContentId = _folderService.getContentId(
        content.name,
        destinationHiveFolder!,
      );
      await _deleteContent(destinationContentId, destinationHiveFolder);
      await _copyContent(
        content.id,
        toDestinationFolderId,
        destinationHiveFolder,
      );
    }
    // Save changes to Hive
    await _folderStorage.putFolder(
      toDestinationFolderId,
      destinationHiveFolder!,
    );
  }

  /// Rename list of uncopied contents (files/folders)
  /// from a source folder to a destination folder.
  Future<void> renameUncopiedFolderContentsAtDestinationFolder(
    List<FolderContent> contents,
    String fromSourceFolderId,
    String toDestinationFolderId,
  ) async {
    // Get destination folder from Hive
    final destinationHiveFolder = _folderStorage.getFolderById(
      toDestinationFolderId,
    );
    // Loop through each content item and try to move it
    for (final content in contents) {
      // rename folder/file with a new one that does not exist among the destination folder contents
      String newValidName = _folderService.generateNewContentName(
        destination: destinationHiveFolder!,
        contentName: content.name,
        extension: content.extension,
      );
      // Move the content to destination (and remove from source if required)
      String newInstanceId = await _copyContent(
        content.id,
        toDestinationFolderId,
        destinationHiveFolder,
      );
      //rename folder/file with the new one
      _renameContent(newInstanceId, newValidName);
    }

    // Save changes to Hive
    await _folderStorage.putFolder(
      toDestinationFolderId,
      destinationHiveFolder!,
    );
  }

  /// delete content
  Future<void> deleteFolderContentsFromSource(
    List<FolderContent> contents,
    String fromSourceFolderId,
  ) async {
    // Get destination folder from Hive
    final sourceHiveFolder = _folderStorage.getFolderById(fromSourceFolderId);
    // Loop through each content item and try to move it
    for (FolderContent content in contents) {
      await _deleteContent(content.id, sourceHiveFolder!);
    }
    // Save changes to Hive
    await _folderStorage.putFolder(fromSourceFolderId, sourceHiveFolder!);
  }

  void renameContent(String contentID, String newName) async {
    _renameContent(contentID, newName);
  }

  /// Returns a valid and unique file name within the specified folder.
  ///
  /// This method checks whether the given [fileName] already exists inside the folder identified by [folderId].
  /// - If the name exists, it removes the file extension (if any), generates a new unique name using
  ///   [_folderService.generateNewContentName], and then appends the original [extension].
  /// - If the name does not exist, it simply returns the original [fileName].
  ///
  /// Example:
  /// ```dart
  /// getValidFileName('123', 'photo.jpg', 'jpg'); // might return "photo (1).jpg"
  /// ```
  String getValidFileName(String folderId, String fileName, String? extension) {
    // Get folder from Hive
    final hiveFolder = _folderStorage.getFolderById(folderId);
    // check if name is already exist among the destination folder contents
    bool isExist = _folderService.containNameISExists(fileName, hiveFolder!);
    if (!isExist) return fileName;

    // get name Without extension
    String nameWithoutExtension = fileName.contains('.')
        ? fileName.substring(0, fileName.lastIndexOf('.'))
        : fileName;
    // rename folder/file with a new one that does not exist among the destination folder contents
    String newValidName = _folderService.generateNewContentName(
      destination: hiveFolder,
      contentName: nameWithoutExtension,
      extension: extension,
    );
    // Return with original extension (if provided)
    return newValidName;
  }

  Future<void> addFile(
    String toFolderId,
    String filePath,
    FileType fileType,
    String? fileIcon,
    int fileSize,
    String? extension,
    String fileName,
  ) async {
    String? parentPath = _folderService.getFolderPath(toFolderId);
    // save File to hive
    String newFileId = await _fileService.add(
      toFolderId,
      filePath,
      fileType,
      fileIcon,
      fileSize,
      extension,
      fileName,
      parentPath!,
    );
    // save hive file to destination hive folder
    await _folderService.addFile(toFolderId, newFileId);
  }

  /// Moves a content (file or subfolder) to the destination folder.
  void _moveContent(
    FolderContent content,
    HiveFolder destination,
    HiveFolder source,
  ) {
    if (content is SubFolder) {
      _folderService.move(content.id, destination, source);
      source.size--;
    } else {
      _fileService.move(content.id, destination, source);
      source.size--;
    }
    // Increase destination folder size
    destination.size++;
  }

  /// delete a content (file or subfolder) from the specific folder.
  Future<void> _deleteContent(
    String contentId,
    HiveFolder parentHiveFolder,
  ) async {
    if (parentHiveFolder.foldersIds.contains(contentId)) {
      await _folderService.delete(contentId, parentHiveFolder);
    } else {
      await _fileService.delete(contentId, parentHiveFolder);
    }
    parentHiveFolder.size--;
  }

  /// rename folder/file with the new one
  void _renameContent(String contentId, String newName) {
    if (_folderStorage.folderExists(contentId)) {
      _folderService.rename(contentId, newName);
    } else {
      _fileService.rename(contentId, newName);
    }
  }

  Future<String> _copyContent(
    String contentId,
    String toDestinationFolderId,
    HiveFolder destination,
  ) async {
    String newInstanceId;
    if (_folderStorage.folderExists(contentId)) {
      newInstanceId = await _folderService.copy(
        contentId,
        toDestinationFolderId,
        destination,
      );
    } else {
      newInstanceId = await _fileService.copy(
        contentId,
        toDestinationFolderId,
        destination,
      );
    }
    destination.size++;
    return newInstanceId;
  }
}
