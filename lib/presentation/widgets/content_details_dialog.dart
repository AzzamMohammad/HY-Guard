import 'package:ellipsized_text/ellipsized_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hy_guard/core/config/language/l10n/app_localization.dart';
import 'package:hy_guard/core/models/folder_content.dart';
import 'package:hy_guard/core/models/sub_folder.dart';

import 'custom_text_button.dart';
import '../local_storage/utils.dart';
import '../local_storage/widgets/content_icon.dart';

/// A dialog widget that displays detailed information about a [FolderContent] item.
class ContentDetailsDialog extends StatefulWidget {
  final FolderContent content;

  const ContentDetailsDialog({super.key, required this.content});

  @override
  State<ContentDetailsDialog> createState() => _ContentDetailsDialogState();
}

class _ContentDetailsDialogState extends State<ContentDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: REdgeInsets.all(20),

      child: _buildDialogContent(),
    );
  }

  Widget _buildDialogContent() {
    final String contentSize = widget.content is SubFolder
        ? widget.content.size.toString()
        : formatFileSize(widget.content.size);

    return Container(
      width: 1.sw,
      padding: REdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDetailsTitle(),
          SizedBox(height: 20.r),
          _buildContentIconAndName(),
          SizedBox(height: 20.r),
          _buildDetailBar(AppLocalizations.of(context)!.size, contentSize),
          SizedBox(height: 20.r),
          _buildDetailBar(
            AppLocalizations.of(context)!.initial_date,
            buildFormattedDateText(context, widget.content.initDate),
          ),
          SizedBox(height: 20.r),
          _buildDetailBar(AppLocalizations.of(context)!.path, widget.content.virtualPath),
          SizedBox(height: 50.r),
          _buildOKButton(),
        ],
      ),
    );
  }

  Widget _buildDetailsTitle() {
    return Text(
      AppLocalizations.of(context)!.details,
      style: TextTheme.of(
        context,
      ).bodyMedium!.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildContentIconAndName() {
    return Row(
      children: [
        _buildContentIcon(),
        SizedBox(width: 15.w),
        _buildContentName(),
      ],
    );
  }

  Widget _buildContentIcon() {
    return ContentIcon(
      icon: widget.content.icon,
      extension: widget.content.extension,
    );
  }

  Widget _buildContentName() {
    return Expanded(
      child: EllipsizedText(
        widget.content.name,
        style: TextTheme.of(context).bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.visible,
        ),
        type: EllipsisType.middle,
      ),
    );
  }

  Widget _buildDetailBar(String name, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextTheme.of(
            context,
          ).bodyMedium!.copyWith(color: Theme.of(context).hintColor),
        ),
        Text(value),
      ],
    );
  }

  Widget _buildOKButton() {
    return Center(
      child: CustomTextButton(
        label: "OK",
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

void showContentDetailsDialog(BuildContext context, FolderContent content) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black12,
    builder: (contexts) {
      return ContentDetailsDialog(content: content);
    },
  );
}
