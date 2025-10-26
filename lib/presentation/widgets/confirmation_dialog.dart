import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hy_guard/core/config/language/l10n/app_localization.dart';

import 'custom_text_button.dart';

/// A reusable confirmation dialog widget that displays an optional [title] and [description].
///
/// Provides "Cancel" and "Confirm" buttons. The [onConfirm] callback is executed
class ConfirmationDialog extends StatelessWidget {
  final String? title;
  final String? description;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    super.key,
    this.title,
    this.description,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.bottomCenter,
      insetPadding: REdgeInsets.all(20),
      title: title == null ? null : Text(title!),
      content: description == null ? null : Text(description!),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actions: [
        CustomTextButton(
          label: AppLocalizations.of(context)!.cancel,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 15, child: VerticalDivider()),
        CustomTextButton(
          label: AppLocalizations.of(context)!.confirm,
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
