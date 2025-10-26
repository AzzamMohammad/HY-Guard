import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant/assets_names.dart';
import '../../../core/models/folder.dart';

class CurrentFolderPath extends StatelessWidget {
  final double? height;
  final ScrollController pathListListViewController;
  final List<Folder> folders;
  final Function(int) onPathItemTap;

  const CurrentFolderPath({
    super.key,
    this.height,
    required this.pathListListViewController,
    required this.folders,
    required this.onPathItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 30.r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [_buildFolderIcon(context), _buildPathList(context)],
      ),
    );
  }

  Widget _buildFolderIcon(BuildContext context) {
    return Image.asset(
      AssetsNames.homeFolderIcon,
      color: Theme.of(context).iconTheme.color,
      width: 30.r,
      height: 30.r,
    );
  }

  Widget _buildPathList(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: pathListListViewController,
        shrinkWrap: true,
        primary: false,
        scrollDirection: Axis.horizontal,
        itemCount: folders.length,
        itemBuilder: (context, index) {
          bool isNotLastItem = index != folders.length - 1;
          String name = folders[index].name;
          return _pathItem(name, isNotLastItem, index, context);
        },
      ),
    );
  }

  Widget _pathItem(
    String name,
    bool isNotLastItem,
    int index,
    BuildContext context,
  ) {
    final Color? mainColor = isNotLastItem
        ? Theme.of(context).textTheme.bodyMedium!.color!.withAlpha(100)
        : Theme.of(context).textTheme.bodyMedium!.color;
    return TextButton.icon(
      onPressed: () {
        onPathItemTap(index);
      },
      label: Text(name, textScaler: TextScaler.noScaling),
      style: TextButton.styleFrom(
        padding: REdgeInsets.all(0),
        textStyle: TextTheme.of(
          context,
        ).bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        foregroundColor: mainColor,
      ),
      icon: RotatedBox(
        quarterTurns: Directionality.of(context) == TextDirection.ltr ? 0 : 90,
        child: Icon(Icons.play_arrow_rounded, color: mainColor),
      ),
    );
  }
}
