import 'dart:io';
import 'package:hy_guard/data/storage/recent_file_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_image_renderer/pdf_image_renderer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../core/constant/assets_names.dart';
import '../../../core/constant/file_type.dart';
import '../../storage/file_storage.dart';
import '../../storage/folder_storage.dart';

/// Generates a unique ID by combining the given [specialString] with the current timestamp.
///
/// This method appends the current time in microseconds to the provided [specialString],
/// ensuring that the resulting ID is unique for each call.
///
/// Example:
/// ```dart
/// String id = generateUniqueID("file_");
/// // Might return: "file_1707261930123456"
/// ```
String generateUniqueID(String specialString) {
  String hashDate = DateTime.now().microsecondsSinceEpoch.toString();
  return specialString + hashDate;
}

/// Open Hive boxes
Future<void> openHiveBoxes() async {
  await FileStorage().openBox();
  await FolderStorage().openBox();
  await RecentFileStorage().openBox();
}

/// Generates and returns an appropriate file icon path based on the given file type.
///
/// For [video] and [PDF] files, this function generates a representative thumbnail image
/// of the content, saves it to the app’s internal storage, and returns its path.
/// For [image] files, it simply returns the original file path.
/// For all other file types, it returns a predefined icon that represents the file type.
Future<String?> generateFileIcon(
  String filePath,
  FileType type,
  String name,
) async {
  if (type == FileType.image) {
    return filePath;
  } else if (type == FileType.video) {
    File? videoIcon = await generateVideoIcon(filePath);
    return videoIcon != null ? videoIcon.path : AssetsNames.videoFileIcon;
  } else if (type == FileType.pdf) {
    File? pdfIcon = await generatePDFIcon(filePath, name);
    return pdfIcon != null ? pdfIcon.path : AssetsNames.pdfFileIcon;
  } else if (type == FileType.audio) {
    return AssetsNames.audioFileIcon;
  } else if (type == FileType.recorde) {
    return AssetsNames.recordeFileIcon;
  }
  return null;
}

/// Generate an image from the first frame of a video.
/// Returns a File containing the thumbnail, or null if creation fails.
Future<File?> generateVideoIcon(String videoPath) async {
  try {
    String iconStoragePath = await getFilesIconsDirectoryPath();
    final thumbPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: iconStoragePath,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 200,
      quality: 75,
      timeMs: 10000,
    );
    return thumbPath != null ? File(thumbPath) : null;
  } catch (error) {
    return null;
  }
}

/// Generate an image (PNG) from the first page of a PDF file.
Future<File?> generatePDFIcon(String pdfPath, String name) async {
  try {
    String iconStoragePath = await getFilesIconsDirectoryPath();
    final pdf = PdfImageRenderer(path: pdfPath);
    try {
      await pdf.open();
      await pdf.openPage(pageIndex: 0);
      final size = await pdf.getPageSize(pageIndex: 0);
      final img = await pdf.renderPage(
        pageIndex: 0,
        x: 0,
        y: 0,
        width: size.width,
        height: size.height,
        scale: 1,
      );
      final file = File('$iconStoragePath/$name.png');
      await file.writeAsBytes(img!);
      return file;
    } finally {
      await pdf.closePage(pageIndex: 0);
      await pdf.close();
    }
  } catch (error) {
    return null;
  }
}

/// Returns the path for storing local files within the application's support directory.
Future<String> getLocalFilesDirectoryPath() async {
  final appStorage = await getApplicationSupportDirectory();
  return appStorage.path;
}

/// Returns the path for storing file icons within the application's support directory.
Future<String> getFilesIconsDirectoryPath() async {
  final appStorage = await getApplicationSupportDirectory();
  return appStorage.path;
}

/// Adds a file to the app's local storage with a unique timestamp-based name
/// and returns the new file path.
Future<String> addFileToAppStorage(String filePath, String fileName) async {
  // get locale storage path
  String storagePath = await getLocalFilesDirectoryPath();
  String hashDate = DateTime.now().microsecondsSinceEpoch.toString();
  // generate unique name
  String newName = "${hashDate}_$fileName";
  final newFile = File('$storagePath/$newName');
  // save file to storage
  await File(filePath).copy(newFile.path);
  return newFile.path;
}
