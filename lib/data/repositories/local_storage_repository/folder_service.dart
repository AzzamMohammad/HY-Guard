import 'dart:io';
import 'package:hy_guard/data/repositories/local_storage_repository/file_service.dart';
import 'package:hy_guard/data/repositories/local_storage_repository/utils.dart';
import '../../../core/models/folder.dart';
import '../../../core/models/folder_content.dart';
import '../../../core/models/sub_folder.dart';
import '../../storage/file_storage.dart';
import '../../storage/folder_storage.dart';
import '../../storage/models/hive_models/hive_file.dart';
import '../../storage/models/hive_models/hive_folder.dart';

class FolderService {
  late FileService _fileService;
  late FolderStorage _folderStorage;
  late FileStorage _fileStorage;

  FolderService() {
    _fileService = FileService();
    _folderStorage = FolderStorage();
    _fileStorage = FileStorage();
  }

  Future<Folder> createFolder(String folderName, String parentFolderId) async {
    HiveFolder? parentFolder = _folderStorage.getFolderById(parentFolderId);
    // create hive folder object for the new folder
    HiveFolder hiveFolder = HiveFolder(
      parentId: parentFolderId,
      name: folderName,
      filesIds: [],
      initDate: DateTime.now(),
      foldersIds: [],
      size: 0,
      virtualPath: "${parentFolder!.virtualPath}/$folderName",
    );
    // generate new id
    String newHiveFolderId = generateUniqueID(folderName);
    // put hive folder object to folders box with id
    await _folderStorage.putFolder(newHiveFolderId, hiveFolder);
    // update parent folder details
    HiveFolder? parentHiveFolder = _folderStorage.getFolderById(parentFolderId);
    parentHiveFolder!.foldersIds.add(newHiveFolderId);
    parentHiveFolder.size = parentHiveFolder.size + 1;
    await _folderStorage.putFolder(parentFolderId, parentHiveFolder);
    Folder folder = getFolder(folderId: parentFolderId);
    return folder;
  }

  /// create route folder with parent id  = -1
  Future<void> createRootFolder() async {
    HiveFolder rootFolder = HiveFolder(
      parentId: "-1",
      name: "Locale Storage",
      initDate: DateTime.now(),
      filesIds: [],
      foldersIds: [],
      size: 0,
      virtualPath: "/Internal Storage",
    );
    await _folderStorage.putFolder("0", rootFolder);
  }

  /// get folder by Id
  Future<Folder> openFolder(String folderId) async {
    if (folderId == "0") {
      // open HIVE boxes for the first time
      await openHiveBoxes();
      HiveFolder? hiveFolder = _folderStorage.getFolderById("0");
      // if it is the first time in using the local storage
      if (hiveFolder == null) {
        // create root folder
        await createRootFolder();
      }
    }
    Folder folder = getFolder(folderId: folderId);
    return folder;
  }

  /// Converts a HiveFolder object into a Folder object, including its contents.
  Folder getFolder({required String folderId}) {
    HiveFolder? hiveFolder = _folderStorage.getFolderById(folderId);
    if (hiveFolder == null) {
      throw ("Folder is not exist");
    }
    List<FolderContent> contents = _hiveContentsIdsToFolderContents(
      hiveFolder: hiveFolder,
      folderId: folderId,
    );
    // create Folder object
    Folder folder = Folder(
      id: folderId,
      parentId: hiveFolder.parentId,
      name: hiveFolder.name,
      initDate: hiveFolder.initDate,
      contents: contents,
      size: hiveFolder.size,
    );
    return folder;
  }

  /// Converts HiveFolder's folder and file IDs into a list of FolderContent objects
  List<FolderContent> _hiveContentsIdsToFolderContents({
    required HiveFolder hiveFolder,
    required String folderId,
  }) {
    List<FolderContent> folderContent = [];
    folderContent.addAll(_hiveFoldersIdsToContents(hiveFolder));
    folderContent.addAll(
      _fileService.hiveFilesIdsToContents(hiveFolder.filesIds),
    );
    return folderContent;
  }

  /// Converts the list of folder IDs in a HiveFolder to SubFolder objects
  List<SubFolder> _hiveFoldersIdsToContents(HiveFolder hiveFolder) {
    List<SubFolder> subFolders = [];
    for (var folderId in hiveFolder.foldersIds) {
      HiveFolder? childFolder = _folderStorage.getFolderById(folderId);
      if (childFolder != null) {
        subFolders.add(
          _hiveFolderToSubFolderObject(
            hiveFolder: childFolder,
            folderId: folderId,
          ),
        );
      }
    }
    return subFolders;
  }

  /// Converts a HiveFolder object into a SubFolder object
  SubFolder _hiveFolderToSubFolderObject({
    required HiveFolder hiveFolder,
    required String folderId,
  }) {
    SubFolder subFolder = SubFolder(
      id: folderId,
      parentId: hiveFolder.parentId,
      name: hiveFolder.name,
      initDate: hiveFolder.initDate,
      size: hiveFolder.size,
      virtualPath: hiveFolder.virtualPath,
    );
    return subFolder;
  }

  Future<void> addFile(String toFolderId, String fileId) async {
    HiveFolder? parentHiveFolder = _folderStorage.getFolderById(toFolderId);
    parentHiveFolder!.filesIds.add(fileId);
    parentHiveFolder.size = parentHiveFolder.size + 1;
    await _folderStorage.putFolder(toFolderId, parentHiveFolder);
  }

  void move(String contentId, HiveFolder destination, HiveFolder source) {
    _updateContentPath(contentId, destination.virtualPath);
    // Add subfolder to destination
    destination.foldersIds.add(contentId);
    // Remove subfolder from source if needed
    source.foldersIds.remove(contentId);
  }

  void _updateContentPath(String id, String parentPath) {
    HiveFolder? folder = _folderStorage.getFolderById(id);
    folder!.virtualPath = "$parentPath/${folder.name}";
    _folderStorage.putFolder(id, folder);
  }

  Future<void> delete(String fileId, HiveFolder parentHiveFolder) async {
    await _deleteHiveFolder(fileId);
    // Remove folder from parent folder
    parentHiveFolder.foldersIds.remove(fileId);
  }

  Future<void> _deleteHiveFolder(String folderId) async {
    HiveFolder hiveFolder = _folderStorage.getFolderById(folderId)!;
    for (String subFolderId in hiveFolder.foldersIds) {
      await _deleteHiveFolder(subFolderId);
    }
    for (String subFileId in hiveFolder.filesIds) {
      HiveFile? hiveFile = _fileService.getFileById(subFileId);
      File storiedFile = File(hiveFile!.pathInStorage);
      await storiedFile.delete();
      await _fileService.deleteHiveFile(subFileId);
    }
    _folderStorage.deleteFolder(folderId);
  }

  void rename(String contentId, String newName) {
    final folder = _folderStorage.getFolderById(contentId);
    // update name virtual path
    String rotePath = folder!.virtualPath;
    String name = folder.name;
    // remove last name from path
    rotePath = rotePath.substring(0, rotePath.length - name.length);
    // add new name to path
    folder.virtualPath = rotePath + newName;
    // update name
    folder.name = newName;
    _folderStorage.putFolder(contentId, folder);
  }

  Future<String> copy(
    String folderId,
    String toDestinationFolderId,
    HiveFolder destination,
  ) async {
    return await _copyHiveFolder(folderId, toDestinationFolderId, destination);
  }

  Future<String> _copyHiveFolder(
    String folderId,
    String toDestinationFolderId,
    HiveFolder destination,
  ) async {
    HiveFolder mainFolderInstance = _folderStorage.getFolderById(folderId)!;
    HiveFolder newInstanceFolder = mainFolderInstance.copyWith(
      parentId: toDestinationFolderId,
      initDate: DateTime.now(),
      filesIds: [],
      foldersIds: [],
      virtualPath: "${destination.virtualPath}/${mainFolderInstance.name}",
    );
    String newInstanceFolderId = generateUniqueID(newInstanceFolder.name);
    await _folderStorage.putFolder(newInstanceFolderId, newInstanceFolder);
    destination.foldersIds.add(newInstanceFolderId);
    for (String subFolderId in mainFolderInstance.foldersIds) {
      _copyHiveFolder(subFolderId, newInstanceFolderId, newInstanceFolder);
    }
    for (String subFileId in mainFolderInstance.filesIds) {
      _fileService.copy(subFileId, newInstanceFolderId, newInstanceFolder);
    }
    return newInstanceFolderId;
  }

  /// return id of content debend on its name
  String getContentId(String contentName, HiveFolder parentHiveFolder) {
    late String contentId;

    var suchFiles = parentHiveFolder.filesIds.where(
      (fileId) => _fileStorage.getFileById(fileId)?.name == contentName,
    );
    if (suchFiles.isNotEmpty) {
      contentId = suchFiles.first;
    }
    var suchFolder = parentHiveFolder.foldersIds.where(
      (folderId) => _folderStorage.getFolderById(folderId)?.name == contentName,
    );
    if (suchFolder.isNotEmpty) {
      contentId = suchFolder.first;
    }
    return contentId;
  }

  /// Checks if a given name already exists in the folder
  /// (either as a subfolder name or a file name).
  bool containNameISExists(String name, HiveFolder folder) {
    final folderNames = folder.foldersIds
        .map((id) => _folderStorage.getFolderById(id)?.name)
        .whereType<String>();
    final fileNames = folder.filesIds
        .map((id) => _fileStorage.getFileById(id)?.name)
        .whereType<String>();

    return folderNames.contains(name) || fileNames.contains(name);
  }

  /// Generate folder/file with a new one that does not exist among the destination folder contents
  String generateNewContentName({
    required HiveFolder destination,
    required String contentName,
    String? extension,
  }) {
    int count = 1;
    String validName = extension == null
        ? "$contentName ($count)"
        : "$contentName ($count).$extension";
    while (containNameISExists(validName, destination)) {
      count++;
      validName = extension == null
          ? "$contentName ($count)"
          : "$contentName ($count).$extension";
    }
    return validName;
  }

  String? getFolderPath(String folderId) {
    HiveFolder? folder = _folderStorage.getFolderById(folderId);
    if (folder == null) return null;
    return folder.virtualPath;
  }

  /// Searches all stored folders by name and returns a list of matching [FolderContent] objects.
  List<FolderContent> search(String query) {
    List<FolderContent> folders = [];
    // Get all stored folders in Hive and their IDs in a map
    Map<dynamic, HiveFolder> hivesFolders = _folderStorage.getFoldersMap();
    hivesFolders.forEach((key, value) {
      // Check if folder name contains the search query
      if (value.name.contains(query)) {
        folders.add(
          _hiveFolderToSubFolderObject(hiveFolder: value, folderId: key),
        );
      }
    });
    return folders;
  }
}
