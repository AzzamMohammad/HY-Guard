import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hy_guard/core/models/sub_folder.dart';
import 'package:hy_guard/core/utils/reference.dart';
import 'package:hy_guard/presentation/widgets/app_messenger.dart';

import '../../../business/local_storage_bloc/local_storage_bloc.dart';
import '../../../core/config/language/l10n/app_localization.dart';
import '../../../core/constant/assets_names.dart';
import '../../../core/models/folder.dart';
import '../../../core/models/folder_content.dart';
import '../../widgets/custom_text_button.dart';
import '../../widgets/disableable_text_button.dart';
import '../utils.dart';
import 'content_icon.dart';
import 'current_folder_path.dart';
import 'folder_content_view_bar.dart';

class DestinationFolderExplorerDialog extends StatefulWidget {
  final List<Folder> exploredFolders;
  final double sourceFolderPathOffset;
  final int selectedFolderContentsForEditLength;
  final FolderContent firstSelectedContent;
  final Reference<String> toDestinationFolderIdReference;
  final VoidCallback onMoveHereTap;

  const DestinationFolderExplorerDialog({
    super.key,
    required this.exploredFolders,
    required this.sourceFolderPathOffset,
    required this.selectedFolderContentsForEditLength,
    required this.toDestinationFolderIdReference,
    required this.onMoveHereTap, required this.firstSelectedContent,
  });

  @override
  State<DestinationFolderExplorerDialog> createState() =>
      _DestinationFolderExplorerDialogState();
}

class _DestinationFolderExplorerDialogState
    extends State<DestinationFolderExplorerDialog> {
  late List<Folder> _exploredFolders;
  late int _currentFolderIndex;
  late String _sourceFolderId;
  late final ScrollController _openedFoldersPathController;
  late final PageController _folderContentsPageController;

  late final int _selectedFolderContentsForEditLength;
  late final FolderContent _firstSelectedContent;
  late final Reference<String> _toDestinationFolderIdReference;
  late final VoidCallback _onMoveHereTap;

  @override
  void initState() {
    _exploredFolders = [];
    _exploredFolders.addAll(widget.exploredFolders);
    _selectedFolderContentsForEditLength =
        widget.selectedFolderContentsForEditLength;
    _firstSelectedContent = widget.firstSelectedContent;
    _toDestinationFolderIdReference = widget.toDestinationFolderIdReference;
    _onMoveHereTap = widget.onMoveHereTap;
    _currentFolderIndex = widget.exploredFolders.length - 1;
    _sourceFolderId = _exploredFolders.last.id;
    _openedFoldersPathController = ScrollController(
      initialScrollOffset: widget.sourceFolderPathOffset,
    );
    _folderContentsPageController = PageController(
      initialPage: widget.exploredFolders.length - 1,
    );
    super.initState();
  }

  @override
  void dispose() {
    _openedFoldersPathController.dispose();
    _folderContentsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocalStorageBloc, LocalStorageState>(
      listener: _listenToLocalStorageState,
      child: BlocBuilder<LocalStorageBloc, LocalStorageState>(
        builder: (BuildContext context, LocalStorageState state) {
          return Dialog(
            alignment: Alignment.center,
            insetPadding: REdgeInsets.all(10),
            child: _buildDialogContent(),
          );
        },
      ),
    );
  }

  void _listenToLocalStorageState(context, state) {
    if (state is ReturnExploredFolderContentState) {
      _onReturnExploredFolderContent(state);
    }
    if (state is AnErrorHappenState) {
      _onAnErrorHappen();
    }
  }

  void _onReturnExploredFolderContent(dynamic state) {
    _exploredFolders.add(state.folder);
    _currentFolderIndex++;
    _animateToCurrentFolderAndPath(false);
  }

  void _onAnErrorHappen() {
    AppMessenger().showAnErrorHappen(context: context);
  }

  Widget _buildDialogContent() {
    return Container(
      width: 1.sw,
      height: .9.sh,
      padding: REdgeInsets.all(15),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: _onPopPage,
        child: Padding(
          padding: REdgeInsets.all(5),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return ListView(
                children: [
                  _buildTitle(40.r),
                  SizedBox(height: 10.r),
                  _buildElementPath(30.r),
                  _buildFolderContentViewBar(constraints.maxHeight - 160.r),
                  _buildActionButtons(80.r, constraints.maxWidth),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(double height) {
    return SizedBox(
      height: height,
      child: Text(
        AppLocalizations.of(context)!.select_folder,
        style: TextTheme.of(
          context,
        ).titleLarge!.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  void _onPopPage(bool canPop, dynamic result) {
    if (_currentFolderIndex != 0) {
      _goToFolder(_currentFolderIndex - 1);
    }
  }

  Widget _buildElementPath(double height) {
    return CurrentFolderPath(
      height: height,
      pathListListViewController: _openedFoldersPathController,
      folders: _exploredFolders,
      onPathItemTap: _goToFolder,
    );
  }

  Widget _buildFolderContentViewBar(double height) {
    return FolderContentViewBar(
      height: height,
      folderContentsPageController: _folderContentsPageController,
      openedFolders: _exploredFolders,
      isEditModeOpen: false,
      onFolderContentItemTap: _onFolderContentItemTap,
      enableEdit: false,
    );
  }

  void _onFolderContentItemTap(FolderContent contentItem) {
    BlocProvider.of<LocalStorageBloc>(
      context,
    ).add(OpenExploredFolderEvent(folderId: contentItem.id));
  }

  Widget _buildActionButtons(double height, double width) {
    return SizedBox(
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSelectedItemsIcons(),
          Wrap(children: [_buildMoveHereButton(), _buildCancelButton()]),
        ],
      ),
    );
  }

  Widget _buildMoveHereButton() {
    // Button is disabled if no folder selection change has occurred
    return DisableableTextButton(
      isDisabled: _sourceFolderId == _exploredFolders[_currentFolderIndex].id,
      label: AppLocalizations.of(context)!.move_here,
      onPressed: () {
        _toDestinationFolderIdReference.value =
            _exploredFolders[_currentFolderIndex].id;
        _onMoveHereTap();
        Navigator.pop(context);
      },
    );
  }

  Widget _buildCancelButton() {
    return CustomTextButton(
      label: AppLocalizations.of(context)!.cancel,
      onPressed: _cancelFolderCreation,
    );
  }

  void _cancelFolderCreation() {
    Navigator.pop(context);
  }

  Widget _buildSelectedItemsIcons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildSelectedItemsIconsStack(),
        _buildNumberOfSelectedItems(),
      ],
    );
  }

  Widget _buildSelectedItemsIconsStack() {
    // Stack multiple folder icons to indicate multiple selected items.
    // Layers are offset to create a visual stacking effect.
    return SizedBox(
      width: 50.r,
      height: 50.r,
      child: Stack(
        children: [
          _selectedFolderContentsForEditLength > 2
              ? _buildSelectedItemsIconsStackLayer(2, null)
              : Container(),
          _selectedFolderContentsForEditLength > 1
              ? _buildSelectedItemsIconsStackLayer(1, null)
              : Container(),
          _buildSelectedItemsIconsStackLayer(
            0,
            _buildFirstItemIcon(),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberOfSelectedItems() {
    return Padding(
      padding: REdgeInsets.only(right: 8).r,
      child: Text(
        _selectedFolderContentsForEditLength.toString(),
        style: TextTheme.of(
          context,
        ).bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        textScaler: TextScaler.noScaling,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSelectedItemsIconsStackLayer(int layer, Widget? child) {
    return Positioned(
      top: 15.r - (layer * 4).r,
      left: 15.r - (layer * 4).r,
      child: Container(
        width: 25.r,
        height: 25.r,
        decoration: BoxDecoration(
          color: layer == 0
              ? Theme.of(context).dialogTheme.backgroundColor
              : Theme.of(context).primaryColor.withAlpha(255 - (layer * 50)),
          borderRadius: BorderRadius.circular(5).r,
        ),
        child: child,
      ),
    );
  }

  Widget _buildFirstItemIcon(){
    if(_firstSelectedContent is SubFolder){
      return Image.asset(
        AssetsNames.folderIcon,
      );
    }else{
      return ContentIcon(
        icon: _firstSelectedContent.icon,
        extension: _firstSelectedContent.extension,
      );
    }
  }

  void _goToFolder(int folderIndex) {
    while (folderIndex != _exploredFolders.length - 1) {
      _exploredFolders.removeAt(_exploredFolders.length - 1);
    }
    _currentFolderIndex = folderIndex;
    _animateToCurrentFolderAndPath(true);
    setState(() {});
  }

  void _animateToCurrentFolderAndPath(bool animationIsToBack) {
    syncFolderPageAndPathScroll(
      animationIsToBack: animationIsToBack,
      folderContentsPageController: _folderContentsPageController,
      openedFoldersPathController: _openedFoldersPathController,
      openedFolderIndex: _currentFolderIndex,
    );
  }
}
