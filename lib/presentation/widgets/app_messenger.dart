import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:hy_guard/core/config/language/l10n/app_localization.dart';

/// A helper class to show messages in the app using [MaterialBanner]
///
/// Provides convenient methods for displaying success and error messages
/// with a consistent style and automatic dismissal after a given duration.
class AppMessenger {
  MaterialBanner _buildMaterialBanner(String message, ContentType contentType) {
    return MaterialBanner(
      elevation: 1,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      forceActionsBelow: true,
      content: AwesomeSnackbarContent(
        title: '',
        message: message,
        contentType: contentType,
        inMaterialBanner: true,
      ),
      actions: const [SizedBox()],
    );
  }

  void _showMessage(
    MaterialBanner materialBanner,
    Duration showDuration,
    BuildContext context,
  ) {
    final messenger = ScaffoldMessenger.of(context);
    // show message
    messenger
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(materialBanner);

    //dismiss message
    Future.delayed(showDuration, () {
      messenger.hideCurrentMaterialBanner();
    });
  }

  /// Displays a generic "An error happened" message in the [context].
  /// [showDuration] controls how long the message is visible.
  void showAnErrorHappen({
    required BuildContext context,
    Duration showDuration = const Duration(milliseconds: 1500),
  }) {
    showError(
      context: context,
      message: AppLocalizations.of(context)!.an_error_happen,
      showDuration: showDuration,
    );
  }

  /// Displays an error message with the provided [message] in the [context].
  /// [showDuration] controls how long the message is visible.
  void showError({
    required BuildContext context,
    required String message,
    Duration showDuration = const Duration(milliseconds: 1500),
  }) {
    final materialBanner = _buildMaterialBanner(message, ContentType.failure);
    _showMessage(materialBanner, showDuration, context);
  }

  /// Displays a success message with the provided [message] in the [context].
  /// [showDuration] controls how long the message is visible.
  void showSuccess({
    required BuildContext context,
    required String message,
    Duration showDuration = const Duration(milliseconds: 1500),
  }) {
    final materialBanner = _buildMaterialBanner(message, ContentType.success);
    _showMessage(materialBanner, showDuration, context);
  }
}
