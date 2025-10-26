part of 'local_storage_screen.dart';

mixin LocalStorageStateHandler<LocalStorageScreen extends StatefulWidget>
    on State<LocalStorageScreen> {
  void handleLocalStorageState(BuildContext context, dynamic state) {
    // Maps each state type to its corresponding handler function for cleaner and centralized state management.
    final handlers = <Type, Function>{
      AnErrorHappenState: () => _onAnErrorHappen(),
      ReturnFolderContentState: () =>
          _onReturnFolderContent(state as ReturnFolderContentState),
      UpdateFolderContentState: () =>
          _onUpdateFolderContent(state as UpdateFolderContentState),
      FolderCreatedSuccessfullyState: () =>
          _onFolderCreatedSuccessfully(state as FolderCreatedSuccessfullyState),
      FolderContentsMovedSuccessfullyState: () =>
          _onFolderContentsMovedSuccessfully(
            state as FolderContentsMovedSuccessfullyState,
          ),
      SomeFolderContentCanNotBeMovedState: () =>
          _onSomeFolderContentCanNotBeMoved(
            state as SomeFolderContentCanNotBeMovedState,
            context,
          ),
      ResolveSkepMovedFolderContentsState: () =>
          _onResolveUnSkipMovedFolderContents(
            state as ResolveSkepMovedFolderContentsState,
            context,
          ),
      FolderContentReplacedSuccessfullyState: () =>
          _onFolderContentReplacedSuccessfully(
            state as FolderContentReplacedSuccessfullyState,
          ),
      FolderContentRenamedSuccessfullyState: () =>
          _onFolderContentRenamedSuccessfully(
            state as FolderContentRenamedSuccessfullyState,
          ),
      FolderContentsCopiedSuccessfullyState: () =>
          _onFolderContentsCopiedSuccessfully(
            state as FolderContentsCopiedSuccessfullyState,
          ),
      SomeFolderContentCanNotBeCopiedState: () =>
          _onSomeFolderContentCanNotBeCopied(
            state as SomeFolderContentCanNotBeCopiedState,
            context,
          ),
      ResolveSkepCopiedFolderContentsState: () =>
          _onResolveUnSkepCopiedFolderContents(
            state as ResolveSkepCopiedFolderContentsState,
            context,
          ),
      CopiedFolderContentReplacedSuccessfullyState: () =>
          _onCopiedFolderContentReplacedSuccessfully(
            state as CopiedFolderContentReplacedSuccessfullyState,
          ),
      FolderContentsDeletedSuccessfullyState: () =>
          _onFolderContentsDeletedSuccessfully(
            state as FolderContentsDeletedSuccessfullyState,
          ),
      CopiedFolderContentRenamedSuccessfullyState: () =>
          _onCopiedFolderContentRenamedSuccessfully(
            state as CopiedFolderContentRenamedSuccessfullyState,
          ),
      SomePickedFileCanNorSavedState: () =>
          _onSomePickedFileCanNorSaved(state as SomePickedFileCanNorSavedState),
      StartSavingPickedFilesState: () => _onStartSavingPickedFiles(
        state as StartSavingPickedFilesState,
        context,
      ),
      PickedFileSavedSuccessfullyState: () => _onPickedFileSavedSuccessfully(
        state as PickedFileSavedSuccessfullyState,
      ),
    };
    handlers[state.runtimeType]?.call();
  }

  void _onAnErrorHappen() {
    AppMessenger().showAnErrorHappen(context: context);
  }

  void _onReturnFolderContent(ReturnFolderContentState state) async{
    final self = this as _LocalStorageScreenState;
    self._openedFolders.add(state.folder);
    self._openedFolderIndex++;
    self._animateToCurrentFolderAndPath(false);
  }

  void _onUpdateFolderContent(UpdateFolderContentState state) {
    final self = this as _LocalStorageScreenState;

    if (self._onPossibilityOfChangeFoldersContents &&
        self._openedFolderIndex == 0) {
      // on update all folders in [_folders] after possibility of change folders contents
      self._onPossibilityOfChangeFoldersContents = false;
    }
    self._openedFolders[self._openedFolderIndex] = state.folder;
  }

  void _onFolderCreatedSuccessfully(FolderCreatedSuccessfullyState state) {
    final self = this as _LocalStorageScreenState;

    // upload folder content
    self._openedFolders[self._openedFolderIndex] = state.folder;
    // increment parent folder size on screen
    if (self._openedFolderIndex != 0) {
      self._openedFolders[self._openedFolderIndex - 1].contents
          .where((item) {
            return item.id == state.folder.id;
          })
          .first
          .size++;
    }
  }

  void _onFolderContentsMovedSuccessfully(
    FolderContentsMovedSuccessfullyState state,
  ) {
    final self = this as _LocalStorageScreenState;
    self._openedFolders[self._openedFolderIndex] = state.updatedSourceFolder;
    self._onPossibilityOfChangeFoldersContents = true;
    self._closeEditingMode();
    AppMessenger().showSuccess(
      context: context,
      message: AppLocalizations.of(context)!.move_completed,
    );
  }

  void _onSomeFolderContentCanNotBeMoved(
    SomeFolderContentCanNotBeMovedState state,
    BuildContext blocContext,
  ) async {
    final self = this as _LocalStorageScreenState;
    self._openedFolders[self._openedFolderIndex] = state.updatedSourceFolder;
    self._onPossibilityOfChangeFoldersContents = true;
    self._closeEditingMode();
    _showResolveUnmovedFolderContentsDialog(blocContext, state);
  }

  void _onResolveUnSkipMovedFolderContents(
    ResolveSkepMovedFolderContentsState state,
    BuildContext blocContext,
  ) {
    _showResolveUnmovedFolderContentsDialog(blocContext, state);
  }

  void _showResolveUnmovedFolderContentsDialog(
    BuildContext blocContext,
    dynamic state,
  ) async {
    Reference<bool> isDoActionForAllItems = Reference(value: false);
    final bloc = context.read<LocalStorageBloc>();
    ResolveState? resolveState = await showResolveExistingContentProblemDialog(
      context: context,
      firstFolderContentName: state.unMovedFolderContents.first.name,
      isDoActionForAllItems: isDoActionForAllItems,
    );
    if (resolveState != null) {
      if (!context.mounted) return;
      switch (resolveState) {
        case ResolveState.skip:
          bloc.add(
            SkipMovingFolderContentsEvent(
              contents: state.unMovedFolderContents,
              fromSourceFolderId: state.fromSourceFolderId,
              toDestinationFolderId: state.toDestinationFolderId,
              isSkipForAll: isDoActionForAllItems.value,
            ),
          );
        case ResolveState.replace:
          bloc.add(
            ReplaceUnmovedFolderContentsEvent(
              contents: state.unMovedFolderContents,
              fromSourceFolderId: state.fromSourceFolderId,
              toDestinationFolderId: state.toDestinationFolderId,
              isReplacingForAll: isDoActionForAllItems.value,
            ),
          );
        case ResolveState.rename:
          bloc.add(
            RenameUnmovedFolderContentsEvent(
              contents: state.unMovedFolderContents,
              fromSourceFolderId: state.fromSourceFolderId,
              toDestinationFolderId: state.toDestinationFolderId,
              isRenameForAll: isDoActionForAllItems.value,
            ),
          );
      }
    }
  }

  void _onFolderContentReplacedSuccessfully(
    FolderContentReplacedSuccessfullyState state,
  ) {
    final self = this as _LocalStorageScreenState;
    self._openedFolders[self._openedFolderIndex] = state.updatedSourceFolder;
    self._onPossibilityOfChangeFoldersContents = true;
    AppMessenger().showSuccess(
      context: context,
      message: AppLocalizations.of(context)!.replace_completed,
    );
  }

  void _onFolderContentRenamedSuccessfully(
    FolderContentRenamedSuccessfullyState state,
  ) {
    final self = this as _LocalStorageScreenState;
    self._openedFolders[self._openedFolderIndex] = state.updatedSourceFolder;
    self._onPossibilityOfChangeFoldersContents = true;
    AppMessenger().showSuccess(
      context: context,
      message: AppLocalizations.of(context)!.rename_completed,
    );
  }

  void _onFolderContentsCopiedSuccessfully(
    FolderContentsCopiedSuccessfullyState state,
  ) {
    final self = this as _LocalStorageScreenState;
    self._openedFolders[self._openedFolderIndex] = state.updatedSourceFolder;
    self._onPossibilityOfChangeFoldersContents = true;
    self._closeEditingMode();
    AppMessenger().showSuccess(context: context, message: AppLocalizations.of(context)!.copy_completed);
  }

  void _onSomeFolderContentCanNotBeCopied(
    SomeFolderContentCanNotBeCopiedState state,
    BuildContext blocContext,
  ) async {
    final self = this as _LocalStorageScreenState;
    self._openedFolders[self._openedFolderIndex] = state.updatedSourceFolder;
    self._onPossibilityOfChangeFoldersContents = true;
    self._closeEditingMode();
    _showResolveUnCopiedFolderContentsDialog(blocContext, state);
  }

  void _onResolveUnSkepCopiedFolderContents(
    ResolveSkepCopiedFolderContentsState state,
    BuildContext blocContext,
  ) {
    _showResolveUnCopiedFolderContentsDialog(blocContext, state);
  }

  Future<void> _showResolveUnCopiedFolderContentsDialog(
    BuildContext blocContext,
    dynamic state,
  ) async {
    Reference<bool> isDoActionForAllItems = Reference(value: false);
    final bloc = context.read<LocalStorageBloc>();
    ResolveState? resolveState = await showResolveExistingContentProblemDialog(
      context: context,
      firstFolderContentName: state.unMovedFolderContents.first.name,
      isDoActionForAllItems: isDoActionForAllItems,
    );
    if (resolveState != null) {
      if (!context.mounted) return;
      switch (resolveState) {
        case ResolveState.skip:
          bloc.add(
            SkipCopingFolderContentsEvent(
              contents: state.unMovedFolderContents,
              fromSourceFolderId: state.fromSourceFolderId,
              toDestinationFolderId: state.toDestinationFolderId,
              isSkipForAll: isDoActionForAllItems.value,
            ),
          );
        case ResolveState.replace:
          bloc.add(
            ReplaceUncopiedFolderContentsEvent(
              contents: state.unMovedFolderContents,
              fromSourceFolderId: state.fromSourceFolderId,
              toDestinationFolderId: state.toDestinationFolderId,
              isReplacingForAll: isDoActionForAllItems.value,
            ),
          );
        case ResolveState.rename:
          bloc.add(
            RenameUncopiedFolderContentsEvent(
              contents: state.unMovedFolderContents,
              fromSourceFolderId: state.fromSourceFolderId,
              toDestinationFolderId: state.toDestinationFolderId,
              isRenameForAll: isDoActionForAllItems.value,
            ),
          );
      }
    }
  }

  void _onCopiedFolderContentReplacedSuccessfully(
    CopiedFolderContentReplacedSuccessfullyState state,
  ) {
    final self = this as _LocalStorageScreenState;
    self._onPossibilityOfChangeFoldersContents = true;
    AppMessenger().showSuccess(
      context: context,
      message: AppLocalizations.of(context)!.replace_completed,
    );
  }

  void _onFolderContentsDeletedSuccessfully(
    FolderContentsDeletedSuccessfullyState state,
  ) {
    final self = this as _LocalStorageScreenState;
    // upload folder content
    self._openedFolders[self._openedFolderIndex] = state.folder;
    // decrement parent folder size on screen
    self._onPossibilityOfChangeFoldersContents = true;
    self._closeEditingMode();
    AppMessenger().showSuccess(context: context, message:AppLocalizations.of(context)!.delete_completed);
  }

  void _onCopiedFolderContentRenamedSuccessfully(
    CopiedFolderContentRenamedSuccessfullyState state,
  ) {
    final self = this as _LocalStorageScreenState;
    self._onPossibilityOfChangeFoldersContents = true;
    AppMessenger().showSuccess(
      context: context,
      message: AppLocalizations.of(context)!.rename_completed,
    );
  }

  void _onSomePickedFileCanNorSaved(SomePickedFileCanNorSavedState state) {
    AppMessenger().showError(
      context: context,
      message: AppLocalizations.of(context)!.some_files_can_not_saved,
    );
  }

  void _onStartSavingPickedFiles(
    StartSavingPickedFilesState state,
    BuildContext buildContext,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black12,
      builder: (_) {
        final bloc = buildContext.read<LocalStorageBloc>();
        return BlocProvider.value(
          value: bloc,
          child: SavingPickedFilesStateDialog(
            pickedFilesCount: state.pickedFilesCount,
            currentFileName: state.firstFileName,
          ),
        );
      },
    );
  }

  void _onPickedFileSavedSuccessfully(PickedFileSavedSuccessfullyState state) {
    AppMessenger().showSuccess(
      context: context,
      message: AppLocalizations.of(context)!.files_saved_successfully,
    );
  }
}
