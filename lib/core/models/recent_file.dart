import '../constant/storage_type.dart';

class RecentFile {
  final String id;
  final StorageType storageType;
  final DateTime lastModified;

  RecentFile({
    required this.id,
    required this.storageType,
    required this.lastModified,
  });
}
