import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:intl/intl.dart';

import '../../core/config/language/l10n/app_localization.dart';

/// Animates both the PageView (folders) and the ListView (path)
/// to keep them in sync with the current folder index.
///
/// [animationIsToBack] = true → animate backwards,
/// false → animate forwards .
void syncFolderPageAndPathScroll({
  required bool animationIsToBack,
  required final ScrollController openedFoldersPathController,
  required final PageController folderContentsPageController,
  required int openedFolderIndex,
  Duration? duration,
}) {
  // Calculate the offset based on the animation direction:
  // - Backwards → extentBefore (distance before current position).
  // - Forwards  → extentTotal (total scroll extent).
  final double offset = animationIsToBack
      ? openedFoldersPathController.position.extentBefore
      : openedFoldersPathController.position.extentTotal;
  folderContentsPageController.animateToPage(
    openedFolderIndex,
    duration: duration ?? const Duration(milliseconds: 700),
    curve: Curves.linearToEaseOut,
  );
  openedFoldersPathController.animateTo(
    offset,
    duration: duration ?? const Duration(milliseconds: 700),
    curve: Curves.linearToEaseOut,
  );
}

/// Converts a file size in bytes into a human-readable string format.
///
/// Examples:
/// - 512 → "512 B"
/// - 2048 → "2 KB"
/// - 1048576 → "1 MB"
///
/// Returns a formatted size string with the appropriate unit (B, KB, MB, GB, TB).
String formatFileSize(int fileSize) {
  if (fileSize <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB"];
  int i = (math.log(fileSize) / math.log(1024)).floor();
  double size = fileSize / math.pow(1024, i);
  return "${size.round()} ${suffixes[i]}";
}

/// Builds a localized, human-readable date text widget.
///
/// If the given [initDate] is in the current year, the year is omitted
/// (e.g., "15 Oct 3:45 PM"). Otherwise, the year is included
/// (e.g., "15 Oct 2024 3:45 PM").
///
/// The date format adapts to the app’s current locale and uses
/// the theme’s small body text style.
String buildFormattedDateText(BuildContext context, DateTime initDate) {
  final now = DateTime.now();
  final isCurrentYear = initDate.year == now.year;

  final pattern = isCurrentYear ? "d MMM h:mm a" : "d MMM yyyy h:mm a";

  return DateFormat(
    pattern,
    AppLocalizations.of(context)!.localeName,
  ).format(initDate);
}
