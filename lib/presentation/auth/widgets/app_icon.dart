import 'package:flutter/material.dart';

import '../../../core/constant/assets_names.dart';

/// A widget that displays an app icon.
class AppIcon extends StatelessWidget {
  final double iconSize;

  const AppIcon({super.key, required this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetsNames.hyGuardAppIcon,
      fit: BoxFit.contain,
      height: iconSize,
      width: iconSize,
    );
  }
}
