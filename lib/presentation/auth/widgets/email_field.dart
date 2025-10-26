import 'package:flutter/material.dart';
import '../../../core/config/language/l10n/app_localization.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        label: Text(AppLocalizations.of(context)!.email),
      ),
      validator: (value) {
        return _buildEmailValidator(value, context);
      },
    );
  }

  String? _buildEmailValidator(
    final String? value,
    final BuildContext context,
  ) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_your_email;
    }
    const String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    if (!RegExp(pattern).hasMatch(value)) {
      return AppLocalizations.of(context)!.invalid_email_format;
    }
    return null;
  }
}
