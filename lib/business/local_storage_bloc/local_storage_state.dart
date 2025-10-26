part of 'local_storage_bloc.dart';

@immutable
sealed class LocalStorageState {}

final class LocalStorageInitial extends LocalStorageState {}

final class ReturnFolderContentState extends LocalStorageState {
  final Folder folder;

  ReturnFolderContentState({required this.folder});
}

final class UpdateFolderContentState extends LocalStorageState {
  final Folder folder;

  UpdateFolderContentState({required this.folder});
}

final class ReturnExploredFolderContentState extends LocalStorageState {
  final Folder folder;

  ReturnExploredFolderContentState({required this.folder});
}

final class FolderCreatedSuccessfullyState extends LocalStorageState {
  final Folder folder;

  FolderCreatedSuccessfullyState({required this.folder});
}

final class AnErrorHappenState extends LocalStorageState {
  final String? errorMessage;

  AnErrorHappenState({this.errorMessage});
}

final class FolderContentsMovedSuccessfullyState extends LocalStorageState {
  final Folder updatedSourceFolder;

  FolderContentsMovedSuccessfullyState({required this.updatedSourceFolder});
}

final class SomeFolderContentCanNotBeMovedState extends LocalStorageState {
  final List<FolderContent> unMovedFolderContents;
  final Folder updatedSourceFolder;
  final String fromSourceFolderId;
  final String toDestinationFolderId;

  SomeFolderContentCanNotBeMovedState({
    required this.unMovedFolderContents,
    required this.updatedSourceFolder,
    required this.toDestinationFolderId,
    required this.fromSourceFolderId,
  });
}

final class FolderContentReplacedSuccessfullyState extends LocalStorageState {
  final Folder updatedSourceFolder;

  FolderContentReplacedSuccessfullyState({required this.updatedSourceFolder});
}

final class FolderContentRenamedSuccessfullyState extends LocalStorageState {
  final Folder updatedSourceFolder;

  FolderContentRenamedSuccessfullyState({required this.updatedSourceFolder});
}

final class ResolveSkepMovedFolderContentsState extends LocalStorageState {
  final List<FolderContent> unMovedFolderContents;
  final String fromSourceFolderId;
  final String toDestinationFolderId;

  ResolveSkepMovedFolderContentsState({
    required this.unMovedFolderContents,
    required this.toDestinationFolderId,
    required this.fromSourceFolderId,
  });
}

final class FolderContentsCopiedSuccessfullyState extends LocalStorageState {
  final Folder updatedSourceFolder;
  FolderContentsCopiedSuccessfullyState({required this.updatedSourceFolder});
}

final class SomeFolderContentCanNotBeCopiedState extends LocalStorageState {
  final List<FolderContent> unMovedFolderContents;
  final Folder updatedSourceFolder;
  final String fromSourceFolderId;
  final String toDestinationFolderId;

  SomeFolderContentCanNotBeCopiedState({
    required this.unMovedFolderContents,
    required this.updatedSourceFolder,
    required this.toDestinationFolderId,
    required this.fromSourceFolderId,
  });
}

final class ResolveSkepCopiedFolderContentsState extends LocalStorageState {
  final List<FolderContent> unMovedFolderContents;
  final String fromSourceFolderId;
  final String toDestinationFolderId;

  ResolveSkepCopiedFolderContentsState({
    required this.unMovedFolderContents,
    required this.toDestinationFolderId,
    required this.fromSourceFolderId,
  });
}

final class CopiedFolderContentReplacedSuccessfullyState
    extends LocalStorageState {
  CopiedFolderContentReplacedSuccessfullyState();
}

final class CopiedFolderContentRenamedSuccessfullyState
    extends LocalStorageState {
  CopiedFolderContentRenamedSuccessfullyState();
}

final class FolderContentsDeletedSuccessfullyState extends LocalStorageState {
  final Folder folder;

  FolderContentsDeletedSuccessfullyState({required this.folder});
}

final class SomePickedFileCanNorSavedState extends LocalStorageState {
  SomePickedFileCanNorSavedState();
}

final class PickedFileSavedSuccessfullyState extends LocalStorageState {
  PickedFileSavedSuccessfullyState();
}

final class StartSavingPickedFilesState extends LocalStorageState {
  final int pickedFilesCount;
  final String firstFileName;

  StartSavingPickedFilesState({
    required this.pickedFilesCount,
    required this.firstFileName,
  });
}

final class UpdateSavingPickedFilesState extends LocalStorageState {
  final int pickedFilesCount;
  final int currentPickedFilesIndex;
  final String currentFileName;

  UpdateSavingPickedFilesState({
    required this.pickedFilesCount,
    required this.currentPickedFilesIndex,
    required this.currentFileName,
  });
}

final class CloseSavingPickedFilesState extends LocalStorageState {
  CloseSavingPickedFilesState();
}
