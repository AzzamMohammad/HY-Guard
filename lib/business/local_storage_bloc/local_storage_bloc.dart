import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hy_guard/core/models/folder.dart';
import 'package:hy_guard/core/models/folder_content.dart';
import 'package:hy_guard/core/utils/either.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/repositories/local_storage_repository/local_storage_repository.dart';

part 'local_storage_event.dart';

part 'local_storage_state.dart';

class LocalStorageBloc extends Bloc<LocalStorageEvent, LocalStorageState> {
  final LocalStorageRepository _repository = LocalStorageRepository();

  LocalStorageBloc() : super(LocalStorageInitial()) {
    on<OpenFolderEvent>(_onOpenFolder);
    on<OpenFileEvent>(_onOpenFile);
    on<UpdateFolderEvent>(_onUpdateFolder);
    on<OpenExploredFolderEvent>(_onOpenExploredFolder);
    on<CreateFolderEvent>(_onCreateFolder);
    on<MoveFolderContentsEvent>(_onMoveFolderContents);
    on<SkipMovingFolderContentsEvent>(_onSkipMovingFolderContents);
    on<ReplaceUnmovedFolderContentsEvent>(_onReplaceUnmovedFolderContents);
    on<RenameUnmovedFolderContentsEvent>(_onRenameUnmovedFolderContents);
    on<CopyFolderContentsEvent>(_onCopyFolderContents);
    on<SkipCopingFolderContentsEvent>(_onSkipCopingFolderContents);
    on<ReplaceUncopiedFolderContentsEvent>(_onReplaceUncopiedFolderContents);
    on<RenameUncopiedFolderContentsEvent>(_onRenameUncopiedFolderContents);
    on<ShareFolderContentsEvent>(_onShareFolderContents);
    on<DeleteFolderContentsEvent>(_onDeleteFolderContents);
    on<RenameContentEvent>(_onRenameContent);
    on<PickFilesEvent>(_onPickFiles);
  }

  void _onOpenFolder(
    OpenFolderEvent event,
    Emitter<LocalStorageState> emit,
  ) async {
    Either<String, Folder> result = await _repository.getFolder(event.folderId);
    _handleFolderResult(
      result,
      (folder) => ReturnFolderContentState(folder: folder),
      emit,
    );
  }

  void _onOpenFile(OpenFileEvent event, Emitter<LocalStorageState> emit) async {
    _repository.addFileToRecentFiles(event.file.id);
    event.file.open();
  }

  void _onUpdateFolder(
    UpdateFolderEvent event,
    Emitter<LocalStorageState> emit,
  ) async {
    Either<String, Folder> result = await _repository.getFolder(event.folderId);
    _handleFolderResult(
      result,
      (folder) => UpdateFolderContentState(folder: folder),
      emit,
    );
  }

  void _onOpenExploredFolder(
    OpenExploredFolderEvent event,
    Emitter<LocalStorageState> emit,
  ) async {
    Either<String, Folder> result = await _repository.getFolder(event.folderId);
    _handleFolderResult(
      result,
      (folder) => ReturnExploredFolderContentState(folder: folder),
      emit,
    );
  }

  void _onCreateFolder(
    CreateFolderEvent event,
    Emitter<LocalStorageState> emit,
  ) async {
    Either<String, Folder> result = await _repository.createFolder(
      event.folderName,
      event.parentFolderId,
    );
    _handleFolderResult(
      result,
      (folder) => FolderCreatedSuccessfullyState(folder: folder),
      emit,
    );
  }

  void _onMoveFolderContents(
    MoveFolderContentsEvent event,
    Emitter<LocalStorageState> emit,
  ) async {
    Either<String, Map<String, dynamic>> result = await _repository
        .moveFolderContents(
          event.contents,
          event.fromSourceFolderId,
          event.toDestinationFolderId,
        );
    if (result.isRight) {
      Map<String, dynamic> successResult = result.fold((l) => {}, (r) => r);
      List<FolderContent> unMovedFolderContents =
          successResult["unmoved_contents"];
      Folder updatedSourceFolder = successResult["updated_source_folder"];
      if (unMovedFolderContents.isEmpty) {
        emit(
          FolderContentsMovedSuccessfullyState(
            updatedSourceFolder: updatedSourceFolder,
          ),
        );
      } else {
        emit(
          SomeFolderContentCanNotBeMovedState(
            unMovedFolderContents: unMovedFolderContents,
            updatedSourceFolder: updatedSourceFolder,
            toDestinationFolderId: event.toDestinationFolderId,
            fromSourceFolderId: event.fromSourceFolderId,
          ),
        );
      }
    } else {
      String? errorMessage = result.fold((l) => l, (r) => null);
      emit(AnErrorHappenState(errorMessage: errorMessage));
    }
  }

  void _onSkipMovingFolderContents(
    SkipMovingFolderContentsEvent event,
    Emitter<LocalStorageState> emit,
  ) async {
    Either<bool, List<FolderContent>> result = _repository
        .skipFolderContentAction(event.contents, event.isSkipForAll);
    if (result.isRight) {
      List<FolderContent> unSkipFolderContents = result.fold(
        (l) => [],
        (r) => r,
      );
      emit(
        ResolveSkepMovedFolderContentsState(
          unMovedFolderContents: unSkipFolderContents,
          toDestinationFolderId: event.toDestinationFolderId,
          fromSourceFolderId: event.fromSourceFolderId,
        ),
      );
    }
  }

  void _onReplaceUnmovedFolderContents(
    ReplaceUnmovedFolderContentsEvent event,
    Emitter<LocalStorageState> emit,
  ) async {
    Either<String, Map<String, dynamic>> result = await _repository
        .replaceUnmovedFolderContents(
          event.contents,
          event.fromSourceFolderId,
          event.toDestinationFolderId,
          event.isReplacingForAll,
        );
    if (result.isRight) {
      Map<String, dynamic> successResult = result.fold((l) => {}, (r) => r);
      List<FolderContent> unMovedFolderContents =
          successResult["unmoved_contents"];
      Folder updatedSourceFolder = successResult["updated_source_folder"];
      if (unMovedFolderContents.isNotEmpty) {
        emit(
          SomeFolderContentCanNotBeMovedState(
            unMovedFolderContents: unMovedFolderContents,
            updatedSourceFolder: updatedSourceFolder,
            toDestinationFolderId: event.toDestinationFolderId,
            fromSourceFolderId: event.fromSourceFolderId,
          ),
        );
      }
      emit(
        FolderContentReplacedSuccessfullyState(
          updatedSourceFolder: updatedSourceFolder,
        ),
      );
    } else {
      String? errorMessage = result.fold((l) => l, (r) => null);
      emit(AnErrorHappenState(errorMessage: errorMessage));
    }
  }

  void _onRenameUnmovedFolderContents(
    RenameUnmovedFolderContentsEvent event,
    Emitter<LocalStorageState> emit,
  ) async {
    Either<String, Map<String, dynamic>> result = await _repository
        .renameUnmovedFolderContents(
          event.contents,
          event.fromSourceFolderId,
          event.toDestinationFolderId,
          event.isRenameForAll,
        );
    if (result.isRight) {
      Map<String, dynamic> successResult = result.fold((l) => {}, (r) => r);
      List<FolderContent> unMovedFolderContents =
          successResult["unmoved_contents"];
      Folder updatedSourceFolder = successResult["updated_source_folder"];
      if (unMovedFolderContents.isNotEmpty) {
        emit(
          SomeFolderContentCanNotBeMovedState(
            unMovedFolderContents: unMovedFolderContents,
            updatedSourceFolder: updatedSourceFolder,
            toDestinationFolderId: event.toDestinationFolderId,
            fromSourceFolderId: event.fromSourceFolderId,
          ),
        );
      }
      emit(
        FolderContentRenamedSuccessfullyState(
          updatedSourceFolder: updatedSourceFolder,
        ),
      );
    } else {
      String? errorMessage = result.fold((l) => l, (r) => null);
      emit(AnErrorHappenState(errorMessage: errorMessage));
    }
  }

  void _onCopyFolderContents(
    CopyFolderContentsEvent event,
    Emitter<LocalStorageState> emit,
  ) async {
    Either<String, Map<String, dynamic>> result = await _repository
        .copyFolderContents(
          event.contents,
          event.fromSourceFolderId,
          event.toDestinationFolderId,
        );
    if (result.isRight) {
      Map<String, dynamic> successResult = result.fold((l) => {}, (r) => r);
      List<FolderContent> unCopiedFolderContents =
      successResult["uncopied_contents"];
      Folder updatedSourceFolder = successResult["updated_source_folder"];
      if (unCopiedFolderContents.isEmpty) {
        emit(FolderContentsCopiedSuccessfullyState(updatedSourceFolder: updatedSourceFolder));
      } else {
        emit(
          SomeFolderContentCanNotBeCopiedState(
            unMovedFolderContents: unCopiedFolderContents,
            updatedSourceFolder: updatedSourceFolder,
            toDestinationFolderId: event.toDestinationFolderId,
            fromSourceFolderId: event.fromSourceFolderId,
          ),
        );
      }
    } else {
      String? errorMessage = result.fold((l) => l, (r) => null);
      emit(AnErrorHappenState(errorMessage: errorMessage));
    }
  }

  void _onSkipCopingFolderContents(
    SkipCopingFolderContentsEvent event,
    Emitter<LocalStorageState> emit,
  ) async {
    Either<bool, List<FolderContent>> result = _repository
        .skipFolderContentAction(event.contents, event.isSkipForAll);
    if (result.isRight) {
      List<FolderContent> unSkipFolderContents = result.fold(
        (l) => [],
        (r) => r,
      );
      emit(
        ResolveSkepCopiedFolderContentsState(
          unMovedFolderContents: unSkipFolderContents,
          toDestinationFolderId: event.toDestinationFolderId,
          fromSourceFolderId: event.fromSourceFolderId,
        ),
      );
    }
  }

  void _onReplaceUncopiedFolderContents(
    ReplaceUncopiedFolderContentsEvent event,
    Emitter<LocalStorageState> emit,
  ) async {
    Either<String, Map<String, dynamic>> result = await _repository
        .replaceUncopiedFolderContents(
          event.contents,
          event.fromSourceFolderId,
          event.toDestinationFolderId,
          event.isReplacingForAll,
        );
    if (result.isRight) {
      Map<String, dynamic> successResult = result.fold((l) => {}, (r) => r);
      List<FolderContent> unCopiedFolderContents =
      successResult["uncopied_contents"];
      Folder updatedSourceFolder = successResult["updated_source_folder"];
      if (unCopiedFolderContents.isNotEmpty) {
        emit(
          SomeFolderContentCanNotBeCopiedState(
            unMovedFolderContents: unCopiedFolderContents,
            updatedSourceFolder: updatedSourceFolder,
            toDestinationFolderId: event.toDestinationFolderId,
            fromSourceFolderId: event.fromSourceFolderId,
          ),
        );
      }
      emit(CopiedFolderContentReplacedSuccessfullyState());
    } else {
      String? errorMessage = result.fold((l) => l, (r) => null);
      emit(AnErrorHappenState(errorMessage: errorMessage));
    }
  }

  void _onDeleteFolderContents(
    DeleteFolderContentsEvent event,
    Emitter<LocalStorageState> emit,
  ) async {
    Either<String, Folder> result = await _repository.deleteFolderContents(
      event.contents,
      event.fromSourceFolderId,
    );
    _handleFolderResult(
      result,
      (folder) => FolderContentsDeletedSuccessfullyState(folder: folder),
      emit,
    );
  }

  void _onRenameUncopiedFolderContents(
    RenameUncopiedFolderContentsEvent event,
    Emitter<LocalStorageState> emit,
  ) async {
    Either<String, Map<String, dynamic>> result = await _repository
        .renameUncopiedFolderContents(
          event.contents,
          event.fromSourceFolderId,
          event.toDestinationFolderId,
          event.isRenameForAll,
        );

    if (result.isRight) {
      Map<String, dynamic> successResult = result.fold((l) => {}, (r) => r);
      List<FolderContent> unCopiedFolderContents =
      successResult["uncopied_contents"];
      Folder updatedSourceFolder = successResult["updated_source_folder"];
      if (unCopiedFolderContents.isNotEmpty) {
        emit(
          SomeFolderContentCanNotBeCopiedState(
            unMovedFolderContents: unCopiedFolderContents,
            updatedSourceFolder: updatedSourceFolder,
            toDestinationFolderId: event.toDestinationFolderId,
            fromSourceFolderId: event.fromSourceFolderId,
          ),
        );
      }
      emit(CopiedFolderContentRenamedSuccessfullyState());
    } else {
      String? errorMessage = result.fold((l) => l, (r) => null);
      emit(AnErrorHappenState(errorMessage: errorMessage));
    }
  }

  void _onShareFolderContents(
    ShareFolderContentsEvent event,
    Emitter<LocalStorageState> emit,
  ) async {
    final params = ShareParams(text: "asd");
    final result = await SharePlus.instance.share(params);

    if (result.status != ShareResultStatus.success) {
      emit(AnErrorHappenState());
    }
  }

  void _onRenameContent(
    RenameContentEvent event,
    Emitter<LocalStorageState> emit,
  ) async {
    Either<String, Folder> result = await _repository.renameSelectedContent(
      event.newName,
      event.contentId,
      event.parentId,
    );
    _handleFolderResult(
      result,
      (folder) =>
          FolderContentRenamedSuccessfullyState(updatedSourceFolder: folder),
      emit,
    );
  }

  void _onPickFiles(
    PickFilesEvent event,
    Emitter<LocalStorageState> emit,
  ) async {
    bool allPickedFilesAreSavesSuccessfully = true;
    // pick files by user
    final FilePickerResult? pickResult = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (pickResult == null) return;
    emit(
      StartSavingPickedFilesState(
        firstFileName: pickResult.files.first.name,
        pickedFilesCount: pickResult.files.length,
      ),
    );
    for (int i = 0; i < pickResult.files.length; i++) {
      Either<String, Folder> result = await _repository
          .savePickedFilesToStorage(event.toFolderId, pickResult.files[i]);
      if (result.isRight) {
        emit(
          UpdateSavingPickedFilesState(
            pickedFilesCount: pickResult.files.length,
            currentPickedFilesIndex: i + 1,
            currentFileName: pickResult.files[i].name,
          ),
        );
        // state of saved file
        Folder? folder = result.fold((l) => null, (r) => r);
        emit(UpdateFolderContentState(folder: folder!));
      } else {
        allPickedFilesAreSavesSuccessfully = false;
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
    emit(CloseSavingPickedFilesState());
    if (!allPickedFilesAreSavesSuccessfully) {
      emit(SomePickedFileCanNorSavedState());
    } else {
      emit(PickedFileSavedSuccessfullyState());
    }
  }

  void _handleFolderResult<E extends LocalStorageState>(
    Either<String, Folder> result,
    E Function(Folder folder) successState,
    Emitter<LocalStorageState> emit,
  ) {
    if (result.isRight) {
      Folder? folder = result.fold((l) => null, (r) => r);
      emit(successState(folder!));
    } else {
      String errorMessage = result.fold((l) => l, (r) => "");
      emit(AnErrorHappenState(errorMessage: errorMessage));
    }
  }
}
