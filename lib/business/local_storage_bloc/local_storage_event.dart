part of 'local_storage_bloc.dart';

@immutable
sealed class LocalStorageEvent {}

final class OpenFolderEvent extends LocalStorageEvent {
  final String folderId;

  OpenFolderEvent({required this.folderId});
}

final class OpenFileEvent extends LocalStorageEvent {
  final FolderContent file;

  OpenFileEvent({required this.file});
}

final class UpdateFolderEvent extends LocalStorageEvent {
  final String folderId;

  UpdateFolderEvent({required this.folderId});
}

final class OpenExploredFolderEvent extends LocalStorageEvent {
  final String folderId;

  OpenExploredFolderEvent({required this.folderId});
}

final class CreateFolderEvent extends LocalStorageEvent {
  final String folderName;
  final String parentFolderId;

  CreateFolderEvent({required this.folderName, required this.parentFolderId});
}

final class MoveFolderContentsEvent extends LocalStorageEvent {
  final List<FolderContent> contents;
  final String fromSourceFolderId;
  final String toDestinationFolderId;

  MoveFolderContentsEvent({
    required this.contents,
    required this.fromSourceFolderId,
    required this.toDestinationFolderId,
  });
}

final class SkipMovingFolderContentsEvent extends LocalStorageEvent {
  final List<FolderContent> contents;
  final String fromSourceFolderId;
  final String toDestinationFolderId;
  final bool isSkipForAll;

  SkipMovingFolderContentsEvent({
    required this.contents,
    required this.fromSourceFolderId,
    required this.toDestinationFolderId,
    required this.isSkipForAll,
  });
}

final class ReplaceUnmovedFolderContentsEvent extends LocalStorageEvent {
  final List<FolderContent> contents;
  final String fromSourceFolderId;
  final String toDestinationFolderId;
  final bool isReplacingForAll;

  ReplaceUnmovedFolderContentsEvent({
    required this.contents,
    required this.fromSourceFolderId,
    required this.toDestinationFolderId,
    required this.isReplacingForAll,
  });
}

final class RenameUnmovedFolderContentsEvent extends LocalStorageEvent {
  final List<FolderContent> contents;
  final String fromSourceFolderId;
  final String toDestinationFolderId;
  final bool isRenameForAll;

  RenameUnmovedFolderContentsEvent({
    required this.contents,
    required this.fromSourceFolderId,
    required this.toDestinationFolderId,
    required this.isRenameForAll,
  });
}

final class CopyFolderContentsEvent extends LocalStorageEvent {
  final List<FolderContent> contents;
  final String fromSourceFolderId;
  final String toDestinationFolderId;

  CopyFolderContentsEvent({
    required this.contents,
    required this.fromSourceFolderId,
    required this.toDestinationFolderId,
  });
}

final class SkipCopingFolderContentsEvent extends LocalStorageEvent {
  final List<FolderContent> contents;
  final String fromSourceFolderId;
  final String toDestinationFolderId;
  final bool isSkipForAll;

  SkipCopingFolderContentsEvent({
    required this.contents,
    required this.fromSourceFolderId,
    required this.toDestinationFolderId,
    required this.isSkipForAll,
  });
}

final class ReplaceUncopiedFolderContentsEvent extends LocalStorageEvent {
  final List<FolderContent> contents;
  final String fromSourceFolderId;
  final String toDestinationFolderId;
  final bool isReplacingForAll;

  ReplaceUncopiedFolderContentsEvent({
    required this.contents,
    required this.fromSourceFolderId,
    required this.toDestinationFolderId,
    required this.isReplacingForAll,
  });
}

final class RenameUncopiedFolderContentsEvent extends LocalStorageEvent {
  final List<FolderContent> contents;
  final String fromSourceFolderId;
  final String toDestinationFolderId;
  final bool isRenameForAll;

  RenameUncopiedFolderContentsEvent({
    required this.contents,
    required this.fromSourceFolderId,
    required this.toDestinationFolderId,
    required this.isRenameForAll,
  });
}

final class DeleteFolderContentsEvent extends LocalStorageEvent {
  final List<FolderContent> contents;
  final String fromSourceFolderId;

  DeleteFolderContentsEvent({
    required this.contents,
    required this.fromSourceFolderId,
  });
}

final class ShareFolderContentsEvent extends LocalStorageEvent {
  final List<FolderContent> contents;

  ShareFolderContentsEvent({required this.contents});
}

final class RenameContentEvent extends LocalStorageEvent {
  final String newName;
  final String contentId;
  final String parentId;

  RenameContentEvent({
    required this.newName,
    required this.contentId,
    required this.parentId,
  });
}

final class PickFilesEvent extends LocalStorageEvent {
  final String toFolderId;

  PickFilesEvent({required this.toFolderId});
}
