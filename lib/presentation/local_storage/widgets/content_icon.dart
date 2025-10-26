import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:octo_image/octo_image.dart';

import '../../../core/constant/assets_names.dart';
import '../../../core/constant/file_type.dart';
import '../../../core/utils/media_file_tipe.dart';

class ContentIcon extends StatelessWidget {
  final String? icon;
  final String? extension;
  final double? width;
  final double? height;

  const ContentIcon({
    super.key,
    this.icon,
    this.extension,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 40.r,
      height: height ?? 40.r,
      child: _buildImageIcon(context),
    );
  }

  Widget _buildImageIcon(BuildContext context) {
    if (icon != null) {
      if (icon!.contains("assets")) {
        return _buildAssetImageIcon();
      }
      if (extension != null) {
        return _buildFileImageIcon(icon!, extension!);
      }
    }
    if (extension == null) {
      return Image.asset(
        AssetsNames.unknownFileIcon,
        color: Theme.of(context).iconTheme.color,
      );
    }
    return _createIconFromExtension(extension!, context);
  }

  Widget _buildAssetImageIcon() {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5).r),
      child: Image.asset(icon!, fit: BoxFit.cover),
    );
  }

  Widget _buildFileImageIcon(String icon, String extension) {
    File imageFile = File(icon);
    final ImageProvider image = FileImage(imageFile);
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5).r),
      clipBehavior: Clip.hardEdge,
      child: OctoImage(
        image: image,
        placeholderBuilder: (context) =>
            _getIconPlaceholder(context, extension),
        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _getIconPlaceholder(BuildContext context, String extension) {
    FileType fileType = getFileType(extension);
    if (fileType == FileType.image) {
      return Image.asset(AssetsNames.imagePlaceholderIcon, fit: BoxFit.cover);
    } else if (fileType == FileType.video) {
      return Image.asset(AssetsNames.videoFileIcon, fit: BoxFit.cover);
    } else if (fileType == FileType.pdf) {
      return _createIconFromExtension(extension, context);
    }
    return Image.asset(
      AssetsNames.unknownFileIcon,
      color: Theme.of(context).iconTheme.color,
    );
  }

  Widget _createIconFromExtension(String extension, BuildContext context) {
    return Container(
      padding: REdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFF3a3a3c),
        borderRadius: BorderRadius.circular(13).r,
      ),
      child: Center(
        child: AutoSizeText(
          extension.toUpperCase(),
          style: TextTheme.of(
            context,
          ).bodyMedium?.copyWith(color: const Color(0xFFa68c7b)),
          maxLines: 1,
        ),
      ),
    );
  }
}
