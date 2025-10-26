import 'package:flutter/material.dart';

import '../../../core/config/language/l10n/app_localization.dart';

/// A reusable search input bar widget.
///
/// Displays a single-line [TextFormField] with a clear (✕) button
class SearchContentBar extends StatelessWidget {
  ///Controls the text being edited in the field.
  final TextEditingController controller;

  ///Called whenever the text value changes.
  final Function(String) onFiledContentChange;

  ///Called when the clear (✕) button is pressed.
  final Function() onCleanTap;

  const SearchContentBar({
    super.key,
    required this.controller,
    required this.onFiledContentChange,
    required this.onCleanTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: true,
      maxLines: 1,
      style: TextTheme.of(
        context,
      ).titleLarge!.copyWith(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.search,
        hintStyle: TextTheme.of(context).titleLarge!.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).hintColor,
        ),
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        suffix: _buildCleanFieldButton(),
      ),
      onChanged: onFiledContentChange,
    );
  }

  Widget _buildCleanFieldButton() {
    return IconButton(onPressed: onCleanTap, icon: Icon(Icons.close));
  }
}
