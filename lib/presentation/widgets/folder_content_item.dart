import 'package:ellipsized_text/ellipsized_text.dart';
import 'package:flutter/material.dart';
import 'package:hy_guard/core/models/folder_content.dart';
import 'package:hy_guard/core/models/sub_folder.dart';
import '../../core/config/language/l10n/app_localization.dart';
import '../local_storage/utils.dart';
import '../local_storage/widgets/content_icon.dart';

class FolderContentItem extends StatelessWidget {
  final FolderContent folderContent;

  const FolderContentItem({super.key, required this.folderContent});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildItemImage(
        folderContent.icon,
        folderContent.extension,
        context,
      ),
      title: _buildItemName(folderContent.name, context),
      subtitle: _buildItemInitDate(folderContent.initDate, context),
      trailing: _buildItemContentDetails(folderContent, context),
    );
  }

  Widget _buildItemImage(
    String? icon,
    String? extension,
    BuildContext context,
  ) {
    return ContentIcon(icon: icon, extension: extension);
  }

  Widget _buildItemName(String name, BuildContext context) {
    return EllipsizedText(
      name,
      style: TextTheme.of(context).bodyMedium!.copyWith(
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.visible,
      ),
      type: EllipsisType.middle,
    );
  }

  Widget _buildItemInitDate(DateTime initDate, BuildContext context) {
    return Text(
      buildFormattedDateText(context, initDate),
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget _buildItemContentDetails(FolderContent content, BuildContext context) {
    if (content is SubFolder) {
      return Text(
        "${folderContent.size} ${AppLocalizations.of(context)!.item}",
        style: TextTheme.of(
          context,
        ).bodySmall!.copyWith(fontWeight: FontWeight.bold),
      );
    } else {
      return Text(
        formatFileSize(folderContent.size),
        style: TextTheme.of(
          context,
        ).bodySmall!.copyWith(fontWeight: FontWeight.bold),
      );
    }
  }
}
