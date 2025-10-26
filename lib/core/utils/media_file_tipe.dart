import '../constant/file_type.dart';

/// Returns the [FileType] enum corresponding to the given file [extension].
///
/// This method checks the provided file extension against predefined lists of
/// image, video, audio, PDF, document, and APK extensions. If the extension
/// matches one of the lists, the corresponding [FileType] is returned.
/// If no match is found, [FileType.unknown] is returned.
///
/// Example:
/// ```dart
/// getFileType('mp4'); // returns FileType.video
/// getFileType('pdf'); // returns FileType.pdf
/// getFileType('xyz'); // returns FileType.unknown
/// ```

FileType getFileType(String? extension) {
  List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
  List<String> videoExtensions = ['mp4', 'avi', 'mov', 'mkv', 'webm'];
  List<String> audioExtensions = ['mp3', 'wav', 'aac', 'flac', 'ogg'];
  List<String> pdfExtensions = ['pdf'];
  List<String> documentExtensions = ['doc', 'docx', 'txt', 'rtf', 'odt', 'xml'];
  List<String> apkExtensions = ['apk'];
  List<String> recordeExtensions = ['m4a', '3gp'];

  if (imageExtensions.contains(extension)) {
    return FileType.image;
  } else if (videoExtensions.contains(extension)) {
    return FileType.video;
  } else if (audioExtensions.contains(extension)) {
    return FileType.audio;
  } else if (recordeExtensions.contains(extension)) {
    return FileType.recorde;
  } else if (pdfExtensions.contains(extension)) {
    return FileType.pdf;
  } else if (documentExtensions.contains(extension)) {
    return FileType.document;
  } else if (apkExtensions.contains(extension)) {
    return FileType.apk;
  } else {
    return FileType.unknown;
  }
}
