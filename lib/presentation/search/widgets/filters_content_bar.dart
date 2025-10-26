import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hy_guard/core/utils/reference.dart';

import '../../../core/config/language/l10n/app_localization.dart';
import '../../../core/constant/file_type.dart';

/// A collapsible filters bar widget used in the search screen.
class FiltersContentBar extends StatefulWidget {
  /// A reference controlling whether the filters bar is expanded or collapsed.
  final Reference<bool> isFiltersBarOpen;

  /// A reference holding the currently selected [FileType] filter (nullable).
  final Reference<FileType?> filter;

  /// The current search query text (used when triggering a new search).
  final String searchQuery;

  /// Callback function triggered when a filter is selected or cleared.
  final Function(String) searchForContent;

  const FiltersContentBar({
    super.key,
    required this.isFiltersBarOpen,
    required this.filter,
    required this.searchQuery,
    required this.searchForContent,
  });

  @override
  State<FiltersContentBar> createState() => _FiltersContentBarState();
}

class _FiltersContentBarState extends State<FiltersContentBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _filterTitle(),
        _buildAnimationFiltersBar(),
        SizedBox(height: 5.h),
        const Divider(),
        SizedBox(height: 5.h),
      ],
    );
  }

  Widget _filterTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.filters,
          style: TextTheme.of(context).titleLarge,
        ),
        _buildOpenCloseFiltersArrow(),
      ],
    );
  }

  Widget _buildOpenCloseFiltersArrow() {
    return AnimatedRotation(
      turns: widget.isFiltersBarOpen.value ? -0.5 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: IconButton(
        onPressed: () {
          setState(() {
            widget.isFiltersBarOpen.value = !widget.isFiltersBarOpen.value;
          });
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(Icons.keyboard_arrow_down),
      ),
    );
  }

  Widget _buildAnimationFiltersBar() {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      firstChild: _buildFiltersContent(),
      secondChild: _buildSelectedFilter(),
      crossFadeState: widget.isFiltersBarOpen.value
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );
  }

  Widget _buildFiltersContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.types,
          style: TextTheme.of(context).bodyLarge!.copyWith(
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildFileTypes(),
      ],
    );
  }

  Widget _buildFileTypes() {
    return Wrap(
      spacing: 4,
      runSpacing: 8,
      children: FileType.values.map((fileType) {
        return _typeButton(fileType);
      }).toList(),
    );
  }

  Widget _typeButton(FileType type) {
    return widget.filter.value == type
        ? FilledButton(
            onPressed: () {
              setState(() {
                widget.filter.value = null;
                widget.searchForContent(widget.searchQuery);
              });
            },
            style: _buttonStyle(),
            child: Text(type.name.capitalize),
          )
        : OutlinedButton(
            onPressed: () {
              setState(() {
                widget.filter.value = type;
                widget.searchForContent(widget.searchQuery);
              });
            },
            style: _buttonStyle(),
            child: Text(type.name.capitalize),
          );
  }

  ButtonStyle _buttonStyle() {
    return ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        return Theme.of(context).textTheme.bodyMedium!.color!;
      }),
      iconColor: WidgetStateProperty.resolveWith<Color>((states) {
        return Theme.of(context).textTheme.bodyMedium!.color!;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
        return Colors.transparent;
      }),
    );
  }

  Widget _buildSelectedFilter() {
    return SizedBox(
      width: double.infinity,
      child: widget.filter.value != null
          ? Text(
              widget.filter.value!.name.capitalize,
              style: TextTheme.of(context).bodyLarge!.copyWith(
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.bold,
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
