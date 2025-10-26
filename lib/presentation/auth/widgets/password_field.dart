import 'package:flutter/material.dart';

import '../../../core/config/language/l10n/app_localization.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordField({super.key, required this.controller});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        label: Text(AppLocalizations.of(context)!.password),
        suffixIcon: _buildEyeButton(),
      ),
      validator: _buildPasswordValidator,
    );
  }

  Widget _buildEyeButton() {
    if (_isPasswordVisible) {
      return IconButton(
        icon: const Icon(Icons.remove_red_eye_outlined),
        onPressed: () {
          setState(() {
            _isPasswordVisible = false;
          });
        },
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.visibility_off_outlined),
        onPressed: () {
          setState(() {
            _isPasswordVisible = true;
          });
        },
      );
    }
  }

  String? _buildPasswordValidator(final String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_your_password;
    } else if (value.length < 8) {
      return AppLocalizations.of(
        context,
      )!.password_must_be_more_than_8_characters;
    } else if (!RegExp(r'^(?=.*[!@#$&*~%])').hasMatch(value)) {
      return AppLocalizations.of(
        context,
      )!.password_must_contain_at_least_one_symbol;
    } else {
      return null;
    }
  }
}
