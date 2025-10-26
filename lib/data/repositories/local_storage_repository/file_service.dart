import 'dart:io';

import 'package:hy_guard/core/models/external_file.dart';
import 'package:hy_guard/data/repositories/local_storage_repository/utils.dart';

import '../../../core/constant/file_type.dart';
import '../../../core/models/document_file.dart';
import '../../../core/models/folder_content.dart';
import '../../storage/file_storage.dart';
import '../../storage/models/hive_models/hive_file.dart';
import '../../storage/models/hive_models/hive_folder.dart';

class FileService {
  late FileStorage _fileStorage;

  FileService() {
    _fileStorage = FileStorage();
  }

  /// Converts the list of file IDs in a HiveFolder to FolderContent objects
  List<FolderContent> hiveFilesIdsToContents(List<String> hiveFilesIds) {
    List<FolderContent> files = [];
    for (var fileId in hiveFilesIds) {
      HiveFile? hiveFile = _fileStorage.getFileById(fileId);
      if (hiveFile != null) {
        if (hiveFile.type == FileType.hyDocx) {
          files.add(
            _hiveFileToDocumentFileObject(hiveFile: hiveFile, fileId: fileId),
          );
        } else {
          files.add(
            _hiveFileToExternalFileObject(hiveFile: hiveFile, fileId: fileId),
          );
        }
      }
    }
    return files;
  }

  /// Converts a HiveFile object into a DocumentFile object
  DocumentFile _hiveFileToDocumentFileObject({
    required HiveFile hiveFile,
    required String fileId,
  }) {
    DocumentFile documentFile = DocumentFile(
      id: fileId,
      parentId: hiveFile.parentId,
      name: hiveFile.name,
      initDate: hiveFile.initDate,
      pathInStorage: hiveFile.pathInStorage,
      size: hiveFile.size,
      virtualPath: hiveFile.virtualPath,
    );
    return documentFile;
  }

  /// Converts a HiveFile object into a external File object
  ExternalFile _hiveFileToExternalFileObject({
    required HiveFile hiveFile,
    required String fileId,
  }) {
    ExternalFile externalFile = ExternalFile(
      id: fileId,
      parentId: hiveFile.parentId,
      name: hiveFile.name,
      initDate: hiveFile.initDate,
      size: hiveFile.size,
      pathInStorage: hiveFile.pathInStorage,
      icon: hiveFile.iconPath,
      extension: hiveFile.extension,
      virtualPath: hiveFile.virtualPath,
    );
    return externalFile;
  }

  HiveFile? getFileById(String id) {
    return _fileStorage.getFileById(id);
  }

  Future<String> add(
    String toFolderId,
    String filePath,
    FileType fileType,
    String? fileIcon,
    int fileSize,
    String? extension,
    String fileName,
    String parentPath,
  ) async {
    HiveFile newFile = HiveFile(
      parentId: toFolderId,
      type: fileType,
      name: fileName,
      initDate: DateTime.now(),
      pathInStorage: filePath,
      size: fileSize,
      extension: extension,
      iconPath: fileIcon,
      virtualPath: "$parentPath/$fileName",
    );
    String newFileId = generateUniqueID(newFile.name);
    await _fileStorage.putFile(newFileId, newFile);
    return newFileId;
  }

  Future<void> delete(String fileId, HiveFolder parentHiveFolder) async {
    HiveFile? hiveFile = getFileById(fileId);
    File storiedFile = File(hiveFile!.pathInStorage);
    await storiedFile.delete();
    if (hiveFile.iconPath != null) {
      String localPath = await getFilesIconsDirectoryPath();
      if(hiveFile.iconPath!.contains(localPath)) {
        File storiedFileIcon = File(hiveFile.iconPath!);
        await storiedFileIcon.delete();
      }
    }
    await deleteHiveFile(fileId);
    // Remove file from parent folder
    parentHiveFolder.filesIds.remove(fileId);
  }

  Future<void> deleteHiveFile(String fileId) async {
    await _fileStorage.deleteFile(fileId);
  }

  Future<String> copy(
    String fileId,
    String toDestinationFolderId,
    HiveFolder destination,
  ) async {
    HiveFile? hiveFile = getFileById(fileId);
    String? newStoriedFile = await addFileToAppStorage(
      hiveFile!.pathInStorage,
      hiveFile.name,
    );
    String? newStoriedIconFile;
    if (hiveFile.iconPath != null) {
      String localPath = await getFilesIconsDirectoryPath();
      if(hiveFile.iconPath!.contains(localPath)){
        newStoriedIconFile = await addFileToAppStorage(
          hiveFile.iconPath!,
          hiveFile.name,
        );
      }else{
        newStoriedIconFile = hiveFile.iconPath;
      }

    }
    return await _copyHiveFile(
      fileId,
      toDestinationFolderId,
      destination,
      newStoriedFile,
      newStoriedIconFile,
    );
  }

  Future<String> _copyHiveFile(
    String fileId,
    String toDestinationFolderId,
    HiveFolder destination,
    String newStoriedFile,
    String? newStoriedIconFile,
  ) async {
    HiveFile mainFileInstance = _fileStorage.getFileById(fileId)!;
    HiveFile newFileInstance = mainFileInstance.copyWith(
      parentId: toDestinationFolderId,
      initDate: DateTime.now(),
      pathInStorage: newStoriedFile,
      iconPath: newStoriedIconFile,
      virtualPath: "${destination.virtualPath}/${mainFileInstance.name}",
    );
    String newInstanceFileId = generateUniqueID(newFileInstance.name);
    await _fileStorage.putFile(newInstanceFileId, newFileInstance);
    destination.filesIds.add(newInstanceFileId);
    return newInstanceFileId;
  }

  void move(String contentId, HiveFolder destination, HiveFolder source) {
    _updateContentPath(contentId, destination.virtualPath);
    // Add file to destination
    destination.filesIds.add(contentId);
    // Remove file from source if needed
    source.filesIds.remove(contentId);
  }

  void _updateContentPath(String id, String parentPath) {
    HiveFile? file = _fileStorage.getFileById(id);
    file!.virtualPath = "$parentPath/${file.name}";
    _fileStorage.putFile(id, file);
  }

  void rename(String contentId, String newName) {
    final file = _fileStorage.getFileById(contentId);
    // update name virtual path
    String rotePath = file!.virtualPath;
    String name = file.name;
    // remove last name from path
    rotePath = rotePath.substring(0, rotePath.length - name.length);
    // add new name to path
    file.virtualPath = rotePath + newName;
    file.name = newName;
    _fileStorage.putFile(contentId, file);
  }

  /// Searches all stored files by name and optional [type],
  /// and returns a list of matching [FolderContent] objects.
  List<FolderContent> search(String query, FileType? type) {
    List<FolderContent> files = [];
    // Get all stored files in Hive and their IDs in a map
    Map<dynamic, HiveFile> hivesFiles = _fileStorage.getFilesMap();
    hivesFiles.forEach((key, value) {
      final matchesQuery = (query == "" || value.name.contains(query));
      final matchesType = (type == null || value.type == type);

      if (matchesQuery && matchesType) {
        files.add(
          value.type == FileType.hyDocx
              ? _hiveFileToDocumentFileObject(hiveFile: value, fileId: key)
              : _hiveFileToExternalFileObject(hiveFile: value, fileId: key),
        );
      }
    });
    return files;
  }
}
