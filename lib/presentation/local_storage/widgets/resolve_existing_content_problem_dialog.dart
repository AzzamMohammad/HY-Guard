import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hy_guard/core/utils/reference.dart';

import '../../../core/config/language/l10n/app_localization.dart';
import '../../widgets/custom_text_button.dart';

/// Enum to represent the action chosen by the user in the dialog
enum ResolveState { skip, replace, rename }

/// Dialog to resolve conflicts when folder contents already exist
class ResolveExistingContentProblemDialog extends StatefulWidget {
  final Reference<bool> isDoActionForAllItems;
  final String firstFolderContentName;

  const ResolveExistingContentProblemDialog({
    super.key,
    required this.isDoActionForAllItems,
    required this.firstFolderContentName,
  });

  @override
  State<ResolveExistingContentProblemDialog> createState() =>
      _ResolveExistingContentProblemDialogState();
}

class _ResolveExistingContentProblemDialogState
    extends State<ResolveExistingContentProblemDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: REdgeInsets.all(20),
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: REdgeInsets.all(15),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogTitle(),
              SizedBox(height: 10.h),
              _buildDialogDescription(),
              _buildDoActionForAllSimilarItems(),
              SizedBox(height: 10.h),
              _buildDialogActions(constraints),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDialogTitle() {
    return Text(
      AppLocalizations.of(context)!.rename_folder_or_replace_existing_one,
      style: TextTheme.of(context).bodyLarge!.copyWith(
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
      ),
      maxLines: 2,
    );
  }

  Widget _buildDialogDescription() {
    final String firestItemName = widget.firstFolderContentName;
    return Text(
      "${AppLocalizations.of(context)!.you_already_have_a_folder_named} $firestItemName ${AppLocalizations.of(context)!.in_the_destination_folder}",
      maxLines: 2,
      style: TextTheme.of(
        context,
      ).bodyMedium!.copyWith(overflow: TextOverflow.ellipsis),
    );
  }

  Widget _buildDoActionForAllSimilarItems() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildDoActionForAllSimilarItemsCheckBox(),
        _buildDoActionForAllSimilarItemsLabel(),
      ],
    );
  }

  Widget _buildDoActionForAllSimilarItemsCheckBox() {
    return Checkbox(
      value: widget.isDoActionForAllItems.value,
      onChanged: _onDoActionForAllSimilarItemsChackBoxValueChange,
      shape: CircleBorder(),
    );
  }

  void _onDoActionForAllSimilarItemsChackBoxValueChange(bool? value) {
    setState(() {
      widget.isDoActionForAllItems.value = value!;
    });
  }

  Widget _buildDoActionForAllSimilarItemsLabel() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _onDoActionForAllSimilarItemsChackBoxValueChange(
            !widget.isDoActionForAllItems.value,
          );
        },
        child: Text(
          AppLocalizations.of(context)!.do_this_for_all_similar_items,
          style: TextTheme.of(
            context,
          ).bodyMedium!.copyWith(overflow: TextOverflow.ellipsis),
          maxLines: 2,
        ),
      ),
    );
  }

  Widget _buildDialogActions(BoxConstraints constraints) {
    final buttonWidth = constraints.maxWidth/3.5;
    return SizedBox(
      width: constraints.maxWidth,
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.spaceEvenly,
        children: [
          _buildSkipFolderButton(buttonWidth),
          const SizedBox(height: 15, child: VerticalDivider()),
          _buildReplaceFolderButton(buttonWidth),
          const SizedBox(height: 15, child: VerticalDivider()),
          _buildRenameFolderButton(buttonWidth),
        ],
      ),
    );
  }

  Widget _buildSkipFolderButton(double width) {
    return SizedBox(
      width: width,
      child: CustomTextButton(
        label: AppLocalizations.of(context)!.skip,
        onPressed: () {
          Navigator.pop(context, ResolveState.skip);
        },
      ),
    );
  }

  Widget _buildReplaceFolderButton(double width) {
    return SizedBox(
      width: width,
      child: CustomTextButton(
        label: AppLocalizations.of(context)!.replace,
        onPressed: () {
          Navigator.pop(context, ResolveState.replace);
        },
      ),
    );
  }

  Widget _buildRenameFolderButton(double width) {
    return SizedBox(
      width: width,
      child: CustomTextButton(
        label: AppLocalizations.of(context)!.rename,
        onPressed: () {
          Navigator.pop(context, ResolveState.rename);
        },
      ),
    );
  }
}

/// show the resolve existing content problem dialog and get the user's choice.
///
/// the result can be one of the [ResolveState] types { [skip] , [replace] , [rename] }
Future<ResolveState?> showResolveExistingContentProblemDialog({
  required BuildContext context,
  required Reference<bool> isDoActionForAllItems,
  required String firstFolderContentName,
}) async {
  return await showDialog<ResolveState>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black12,
    builder: (context) {
      return ResolveExistingContentProblemDialog(
        firstFolderContentName: firstFolderContentName,
        isDoActionForAllItems: isDoActionForAllItems,
      );
    },
  );
}
