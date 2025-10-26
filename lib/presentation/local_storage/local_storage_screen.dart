import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hy_guard/business/local_storage_bloc/local_storage_bloc.dart';
import 'package:hy_guard/core/config/language/l10n/app_localization.dart';
import 'package:hy_guard/core/constant/app_routes_names.dart';
import 'package:hy_guard/core/models/folder.dart';
import 'package:hy_guard/core/models/folder_content.dart';
import 'package:hy_guard/core/models/sub_folder.dart';
import 'package:hy_guard/presentation/local_storage/utils.dart';
import 'package:hy_guard/presentation/widgets/content_details_dialog.dart';
import 'package:hy_guard/presentation/local_storage/widgets/content_name_dialog.dart';
import 'package:hy_guard/presentation/local_storage/widgets/current_folder_path.dart';
import 'package:hy_guard/presentation/local_storage/widgets/default_mode_app_bar.dart';
import 'package:hy_guard/presentation/local_storage/widgets/edit_tool_bar.dart';
import 'package:hy_guard/presentation/local_storage/widgets/folder_content_view_bar.dart';
import 'package:hy_guard/presentation/local_storage/widgets/resolve_existing_content_problem_dialog.dart';
import 'package:hy_guard/presentation/local_storage/widgets/saving_picked_files_state_dialog.dart';
import 'package:hy_guard/presentation/local_storage/widgets/select_mode_app_bar.dart';
import 'package:hy_guard/presentation/widgets/confirmation_dialog.dart';
import 'package:hy_guard/presentation/local_storage/widgets/destination_folder_explorer_dialog.dart';
import '../../core/utils/reference.dart';
import '../widgets/app_messenger.dart';

part 'local_storage_state_handler.dart';

class LocalStorageScreen extends StatefulWidget {
  const LocalStorageScreen({super.key});

  @override
  State<LocalStorageScreen> createState() => _LocalStorageScreenState();
}

class _LocalStorageScreenState extends State<LocalStorageScreen>
    with LocalStorageStateHandler<LocalStorageScreen> {
  late List<FolderContent> _selectedFolderContentsForEdit;
  late final PageController _folderContentsPageController;
  late final ScrollController _openedFoldersPathController;
  late bool _canPop;
  late bool _isEditModeOpen;
  late final GlobalKey _editToolButtonKey;
  late List<Folder> _openedFolders;
  late int _openedFolderIndex;
  late bool _onPossibilityOfChangeFoldersContents;

  @override
  void initState() {
    super.initState();
    _openedFolders = [];
    _selectedFolderContentsForEdit = [];
    _openedFolderIndex = -1;
    _folderContentsPageController = PageController();
    _openedFoldersPathController = ScrollController();
    _canPop = true;
    _editToolButtonKey = GlobalKey();
    _isEditModeOpen = false;
    _onPossibilityOfChangeFoldersContents = false;
    _getFolderRote();
  }

  void _getFolderRote() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // folder id is 0 == root folder
      BlocProvider.of<LocalStorageBloc>(
        context,
      ).add(OpenFolderEvent(folderId: "0"));
    });
  }

  @override
  void dispose() {
    _folderContentsPageController.dispose();
    _openedFoldersPathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocListener<LocalStorageBloc, LocalStorageState>(
        listener: (context, state) {
          handleLocalStorageState(context, state);
        },
        child: BlocBuilder<LocalStorageBloc, LocalStorageState>(
          builder: (BuildContext context, LocalStorageState state) {
            return _buildLocalStorageScreenContent();
          },
        ),
      ),
      bottomNavigationBar: _buildEditToolBar(),
      floatingActionButton: _isEditModeOpen
          ? SizedBox.shrink()
          : _buildPickFileButton(),
    );
  }

  Widget _buildLocalStorageScreenContent() {
    return SafeArea(
      child: PopScope(
        canPop: _canPop,
        onPopInvokedWithResult: _onPopPage,
        child: Padding(
          padding: REdgeInsets.all(5),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return ListView(
                children: [
                  _buildElementPath(),
                  _buildFolderContent(constraints.maxHeight - 30.h),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _onPopPage(bool canPop, dynamic result) {
    // on pop and editing mode is opened
    if (_isEditModeOpen) {
      _closeEditingMode();
      return;
    }
    // if editing mode is closed and the next user pop is to the rote folder
    if (_openedFolderIndex - 1 == 0) {
      setState(() {
        _canPop = true;
      });
    }

    // pop is not for close the page
    _goToFolder(_openedFolderIndex - 1);
  }

  AppBar _buildAppBar() {
    if (_isEditModeOpen) {
      return _selectModeAppBar();
    } else {
      return _defaultModeAppBar();
    }
  }

  AppBar _defaultModeAppBar() {
    return defaultModeAppBar(
      createNewFolder: _createNewFolder,
      onTapSearch: _goToSearchScreen,
      pickFile: _pickFile,
    );
  }

  void _createNewFolder() async {
    final bloc = context.read<LocalStorageBloc>();
    String? folderName = await showContentNameDialog(
      context: context,
      contents: _openedFolders[_openedFolderIndex].contents,
      dialogTitle: AppLocalizations.of(context)!.create_folder,
      returnNameButtonLabel: AppLocalizations.of(context)!.create,
    );
    if (!context.mounted) return;
    if (folderName == null || folderName.trim().isEmpty) return;
    bloc.add(
      CreateFolderEvent(
        folderName: folderName,
        parentFolderId: _openedFolders[_openedFolderIndex].id,
      ),
    );
  }

  void _goToSearchScreen() {
    Navigator.pushNamed(context, AppRoutesNames.search,);
  }

  AppBar _selectModeAppBar() {
    return selectModeAppBar(
      context: context,
      selectedItemsNumber: _selectedFolderContentsForEdit.length,
      allItemsNumber: _openedFolders[_openedFolderIndex].contents.length,
      onSelectAll: _onSelectedAllContentTap,
    );
  }

  void _onSelectedAllContentTap(bool value) {
    if (value) {
      _selectedFolderContentsForEdit.clear();
      _selectedFolderContentsForEdit.addAll(
        _openedFolders[_openedFolderIndex].contents,
      );
    } else {
      _selectedFolderContentsForEdit.clear();
    }
    setState(() {});
  }

  Widget _buildEditToolBar() {
    return EditToolBar(
      isEditModeOpen: _isEditModeOpen,
      onTapMove: _onTapMove,
      onTapCopy: _onTapCopy,
      onTapShare: _onTapShare,
      onTapDelete: _onTapDelete,
      onTapMore: _onTapMore,
      editToolButtonKey: _editToolButtonKey,
    );
  }

  void _onTapMove(GlobalKey? key) async {
    Reference<String> toDestinationFolderIdReference = Reference(value: "0");
    void onMoveHereTap() {
      context.read<LocalStorageBloc>().add(
        MoveFolderContentsEvent(
          contents: _selectedFolderContentsForEdit,
          fromSourceFolderId: _openedFolders.last.id,
          toDestinationFolderId: toDestinationFolderIdReference.value,
        ),
      );
    }

    _showDestinationFolderExplorerDialog(
      toDestinationFolderIdReference,
      onMoveHereTap,
    );
  }

  void _onTapCopy(GlobalKey? key) async {
    Reference<String> toDestinationFolderIdReference = Reference(value: "0");
    void onMoveHereTap() {
      context.read<LocalStorageBloc>().add(
        CopyFolderContentsEvent(
          contents: _selectedFolderContentsForEdit,
          fromSourceFolderId: _openedFolders.last.id,
          toDestinationFolderId: toDestinationFolderIdReference.value,
        ),
      );
    }

    _showDestinationFolderExplorerDialog(
      toDestinationFolderIdReference,
      onMoveHereTap,
    );
  }

  void _showDestinationFolderExplorerDialog(
    Reference<String> toDestinationFolderIdReference,
    VoidCallback onMoveHereTap,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black12,
      builder: (_) {
        final bloc = context.read<LocalStorageBloc>();
        return BlocProvider.value(
          value: bloc,
          child: DestinationFolderExplorerDialog(
            sourceFolderPathOffset: _openedFoldersPathController.offset,
            exploredFolders: _openedFolders,
            selectedFolderContentsForEditLength:
                _selectedFolderContentsForEdit.length,
            firstSelectedContent: _selectedFolderContentsForEdit.first,
            toDestinationFolderIdReference: toDestinationFolderIdReference,
            onMoveHereTap: onMoveHereTap,
          ),
        );
      },
    );
  }

  void _onTapShare(GlobalKey? key) {
    context.read<LocalStorageBloc>().add(
      ShareFolderContentsEvent(contents: _selectedFolderContentsForEdit),
    );
  }

  void _onTapDelete(GlobalKey? key) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black12,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<LocalStorageBloc>(),
          child: ConfirmationDialog(
            title: AppLocalizations.of(context)!.are_you_sure,
            description: AppLocalizations.of(
              context,
            )!.if_you_delete_the_item_you_will_not_be_able_to_restore_it,
            onConfirm: () {
              context.read<LocalStorageBloc>().add(
                DeleteFolderContentsEvent(
                  contents: _selectedFolderContentsForEdit,
                  fromSourceFolderId: _openedFolders.last.id,
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _onTapMore(GlobalKey? key) {
    final RelativeRect position = _getMenuPosition(key!);
    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          enabled: _selectedFolderContentsForEdit.length == 1,
          onTap: _renameContent,
          child: Text(AppLocalizations.of(context)!.rename),
        ),
        PopupMenuItem(
          enabled: _selectedFolderContentsForEdit.length == 1,
          onTap: _openDetails,
          child: Text(AppLocalizations.of(context)!.details),
        ),
      ],
    );
  }

  RelativeRect _getMenuPosition(GlobalKey key) {
    final RenderBox button =
        key.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(0, -120.r), ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset(0, -120.r)),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );
    return position;
  }

  void _renameContent() async {
    final bloc = context.read<LocalStorageBloc>();
    String? newName = await showContentNameDialog(
      context: context,
      contents: _openedFolders[_openedFolderIndex].contents,
      dialogTitle: AppLocalizations.of(context)!.rename,
      returnNameButtonLabel: AppLocalizations.of(context)!.rename,
      defaultContentName: _selectedFolderContentsForEdit.first.name,
    );
    if (newName != null) {
      if (!context.mounted) return;
      bloc.add(
        RenameContentEvent(
          newName: newName,
          contentId: _selectedFolderContentsForEdit.first.id,
          parentId: _selectedFolderContentsForEdit.first.parentId,
        ),
      );
      _closeEditingMode();
    }
  }

  void _openDetails() {
    showContentDetailsDialog(context, _selectedFolderContentsForEdit.first);
  }

  Widget _buildPickFileButton() {
    return Padding(
      padding: REdgeInsets.all(8.0),
      child: IconButton.filled(
        onPressed: _pickFile,
        icon: Icon(Icons.add),
        padding: REdgeInsets.all(10),
      ),
    );
  }

  void _pickFile() {
    context.read<LocalStorageBloc>().add(
      PickFilesEvent(toFolderId: _openedFolders.last.id),
    );
  }

  Widget _buildElementPath() {
    return CurrentFolderPath(
      pathListListViewController: _openedFoldersPathController,
      folders: _openedFolders,
      onPathItemTap: _goToFolder,
    );
  }

  Widget _buildFolderContent(double widgetHeight) {
    return FolderContentViewBar(
      height: widgetHeight,
      folderContentsPageController: _folderContentsPageController,
      openedFolders: _openedFolders,
      isEditModeOpen: _isEditModeOpen,
      onFolderContentItemTap: _onFolderContentItemTap,
      onFolderContentItemLongPress: _onFolderContentItemLongPress,
      onSelectItem: _updateContentItemStateInFolderContentItemsList,
      selectedFolderContentsForEdit: _selectedFolderContentsForEdit,
      enableEdit: true,
    );
  }

  void _onFolderContentItemTap(FolderContent contentItem) {
    if (_isEditModeOpen) {
      _updateContentItemStateInFolderContentItemsList(contentItem);
    } else {
      _canPop = false;
      _openFolderContent(contentItem);
    }
  }

  void _openFolderContent(FolderContent contentItem) {
    if (contentItem is SubFolder) {
      BlocProvider.of<LocalStorageBloc>(
        context,
      ).add(OpenFolderEvent(folderId: contentItem.id));
    } else {
      BlocProvider.of<LocalStorageBloc>(
        context,
      ).add(OpenFileEvent(file: contentItem));
    }
  }

  void _onFolderContentItemLongPress(FolderContent contentItem) {
    if (_selectedFolderContentsForEdit.contains(contentItem)) {
      return;
    }
    setState(() {
      _selectedFolderContentsForEdit.add(contentItem);
      _isEditModeOpen = true;
      _canPop = false;
    });
  }

  void _updateContentItemStateInFolderContentItemsList(
    FolderContent contentItem,
  ) {
    if (_selectedFolderContentsForEdit.contains(contentItem)) {
      _selectedFolderContentsForEdit.remove(contentItem);
    } else {
      _selectedFolderContentsForEdit.add(contentItem);
    }
    setState(() {});
  }

  void _animateToCurrentFolderAndPath(bool animationIsToBack) {
    syncFolderPageAndPathScroll(
      animationIsToBack: animationIsToBack,
      folderContentsPageController: _folderContentsPageController,
      openedFoldersPathController: _openedFoldersPathController,
      openedFolderIndex: _openedFolderIndex,
    );
  }

  void _goToFolder(int folderIndex) {
    while (folderIndex != _openedFolders.length - 1) {
      _openedFolders.removeAt(_openedFolders.length - 1);
    }
    _openedFolderIndex = folderIndex;
    if (_onPossibilityOfChangeFoldersContents && _openedFolderIndex >= 0) {
      BlocProvider.of<LocalStorageBloc>(
        context,
      ).add(UpdateFolderEvent(folderId: _openedFolders[_openedFolderIndex].id));
    }
    if (_openedFolderIndex == 0) {
      setState(() {
        _canPop = true;
      });
    }
    _animateToCurrentFolderAndPath(true);
    setState(() {});
  }

  void _closeEditingMode() {
    _isEditModeOpen = false;
    _selectedFolderContentsForEdit.clear();
    if (_openedFolderIndex == 0) {
      _canPop = true;
    }
    setState(() {});
  }
}
