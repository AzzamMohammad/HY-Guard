import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hy_guard/core/constant/content_sort.dart';
import 'package:hy_guard/presentation/widgets/custom_divider.dart';
import '../../../core/config/language/l10n/app_localization.dart';
import '../../../core/models/folder.dart';
import '../../../core/models/folder_content.dart';
import '../../widgets/folder_content_item.dart';

class FolderContentViewBar extends StatefulWidget {
  final double height;
  final PageController folderContentsPageController;
  final List<Folder> openedFolders;
  final bool isEditModeOpen;
  final bool enableEdit;
  final List<FolderContent>? selectedFolderContentsForEdit;
  final Function(FolderContent) onFolderContentItemTap;
  final Function(FolderContent)? onFolderContentItemLongPress;
  final Function(FolderContent)? onSelectItem;

  FolderContentViewBar({
    super.key,
    required this.height,
    required this.folderContentsPageController,
    required this.openedFolders,
    required this.isEditModeOpen,
    required this.onFolderContentItemTap,
    required this.enableEdit,
    this.onFolderContentItemLongPress,
    this.onSelectItem,
    this.selectedFolderContentsForEdit,
  }) {
    if (isEditModeOpen && selectedFolderContentsForEdit == null) {
      throw Exception(
        "selectedFolderContentsForEdit must not be null when edit mode is active",
      );
    }
    if (isEditModeOpen && selectedFolderContentsForEdit == null) {
      throw Exception(
        "selectedFolderContentsForEdit must not be null when edit mode is active",
      );
    }
    if (isEditModeOpen && selectedFolderContentsForEdit == null) {
      throw Exception(
        "selectedFolderContentsForEdit must not be null when edit mode is active",
      );
    }
  }

  @override
  State<FolderContentViewBar> createState() => _FolderContentViewBarState();
}

class _FolderContentViewBarState extends State<FolderContentViewBar> {
  late ContentSortType selectedSortType;
  late ContentSortDirection selectedSortDirection;

  @override
  void initState() {
    selectedSortType = ContentSortType.name;
    selectedSortDirection = ContentSortDirection.forward;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: widget.folderContentsPageController,
        itemCount: widget.openedFolders.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          bool folderIsEmpty = widget.openedFolders[index].contents.isEmpty;
          if (folderIsEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.empty_folder),
            );
          }
          return _buildFolderContentList(
            widget.openedFolders[index].contents,
            context,
          );
        },
      ),
    );
  }

  Widget _buildFolderContentList(
    List<FolderContent> contents,
    BuildContext context,
  ) {
    return Scrollbar(
      thickness: 2.w,
      radius: Radius.circular(5).r,
      child: ListView(
        children: [_buildSortBar(context), _buildContentsBar(contents)],
      ),
    );
  }

  Widget _buildSortBar(BuildContext context) {
    return Container(
      padding: REdgeInsets.symmetric(horizontal: 16,vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppLocalizations.of(context)!.all),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildSortTypesMenu(),
              SizedBox(
                height: 15,
                child: VerticalDivider(color: Theme.of(context).hintColor),
              ),
              _buildSortDirection(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortTypesMenu() {
    return PopupMenuButton<ContentSortType>(
      initialValue: selectedSortType,
      onSelected: (value) {},
      itemBuilder: (context) {
        return ContentSortType.values.map((sortType) {
          return PopupMenuItem<ContentSortType>(
            value: sortType,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(sortType.name.capitalize),
                if (sortType == selectedSortType)
                  const Icon(Icons.check, size: 18),
              ],
            ),
          );
        }).toList();
      },
      child: Row(
        children: [
          Icon(Icons.sort),
          SizedBox(width: 10.r),
          Text(selectedSortType.name.capitalize),
        ],
      ),
    );
  }

  Widget _buildSortDirection() {
    return Icon(Icons.keyboard_arrow_down_rounded);
  }

  Widget _buildContentsBar(List<FolderContent> contents) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      physics: NeverScrollableScrollPhysics(),
      itemCount: contents.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            _buildFolderContentsItem(contents[index], context),
            index != contents.length - 1 ? CustomDivider():SizedBox.shrink(),
          ],
        );
      },
    );
  }

  Widget _buildFolderContentsItem(
    FolderContent contentItem,
    BuildContext context,
  ) {
    return InkWell(
      highlightColor: Theme.of(context).primaryColor.withAlpha(70),
      onTap: () {
        widget.onFolderContentItemTap(contentItem);
      },
      onLongPress: () {
        widget.onFolderContentItemLongPress != null
            ? widget.onFolderContentItemLongPress!(contentItem)
            : null;
      },
      child: SizedBox(
        width: 1.sw,
        height: 60.h,
        child: Row(
          children: [
            _buildSelectionBar(contentItem),
            Expanded(child: FolderContentItem(folderContent: contentItem)),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionBar(FolderContent contentItem) {
    if (!widget.enableEdit) {
      return SizedBox();
    }
    return Padding(
      padding: REdgeInsets.symmetric(),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: widget.isEditModeOpen ? 40 : 0,
        height: widget.isEditModeOpen ? 40 : 0,
        child: Center(
          child: AnimatedScale(
            duration: Duration(milliseconds: 300),
            scale: widget.isEditModeOpen ? 1.1 : 0,
            child: Checkbox(
              value: widget.selectedFolderContentsForEdit!.contains(
                contentItem,
              ),
              onChanged: (value) {
                widget.onSelectItem != null
                    ? widget.onSelectItem!(contentItem)
                    : null;
              },
              shape: CircleBorder(),
            ),
          ),
        ),
      ),
    );
  }
}
