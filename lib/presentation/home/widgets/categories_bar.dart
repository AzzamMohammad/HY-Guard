import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hy_guard/core/config/language/l10n/app_localization.dart';
import 'package:hy_guard/core/constant/assets_names.dart';

import '../../../core/constant/app_routes_names.dart';
import '../../../core/constant/file_type.dart';

class FileCategoriesGrid extends StatelessWidget {
  const FileCategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // A predefined list of file categories displayed in the Categories section.
    final List<FileCategory> categories = [
      FileCategory(
        name: AppLocalizations.of(context)!.images,
        icon: AssetsNames.imageCategoryIcon,
        fileType: FileType.image,
      ),
      FileCategory(
        name: AppLocalizations.of(context)!.videos,
        icon: AssetsNames.videoCategoryIcon,
        fileType: FileType.video,
      ),
      FileCategory(
        name: AppLocalizations.of(context)!.audios,
        icon: AssetsNames.audioCategoryIcon,
        fileType: FileType.audio,
      ),
      FileCategory(
        name: AppLocalizations.of(context)!.documents,
        icon: AssetsNames.documentCategoryIcon,
        fileType: FileType.document,
      ),
      FileCategory(
        name: AppLocalizations.of(context)!.other_files,
        icon: AssetsNames.otherCategoryIcon,
        fileType: FileType.unknown,
      ),
      FileCategory(
        name: AppLocalizations.of(context)!.installation_files,
        icon: AssetsNames.apkCategoryIcon,
        fileType: FileType.apk,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [_buildTitle(context), _buildGrid(categories)],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.categories,
      style: TextTheme.of(
        context,
      ).titleLarge!.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildGrid(List<FileCategory> categories) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double minItemWidth = 100.r;
        double minItemHeight = 100.r;
        int crossAxisCount = (constraints.maxWidth / minItemWidth)
            .floor()
            .clamp(1, 6);
        double actualItemWidth = (constraints.maxWidth / crossAxisCount) - 4.r;

        return Wrap(
          spacing: 4,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: categories.map((category) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: actualItemWidth,
                maxWidth: actualItemWidth,
                minHeight: minItemHeight,
              ),
              child: _categoryCard(category, context),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _categoryCard(FileCategory category, context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutesNames.search,
          arguments: {"type": category.fileType},
        );
      },
      child: Card(
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(category.icon, width: 20.r, height: 20.r),
            SizedBox(height: 10.h),
            Text(
              category.name,
              style: TextTheme.of(
                context,
              ).bodySmall!.copyWith(overflow: TextOverflow.ellipsis),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

/// A simple data model that represents a single file category.
class FileCategory {
  final String name;
  final String icon;
  final FileType fileType;

  FileCategory({
    required this.name,
    required this.icon,
    required this.fileType,
  });
}
