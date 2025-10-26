import 'package:flutter/material.dart';

/// A custom text button that can be disabled using the [isDisabled] flag.
/// If [isDisabled] is true, the button will appear disabled and ignore taps.

class DisableableTextButton extends StatelessWidget {
  /// Called when the button is pressed.
  /// Ignored if [isDisabled] is true.
  final VoidCallback? onPressed;

  /// The text displayed inside the button.
  final String label;

  /// Whether the button is disabled.
  final bool isDisabled;

  const DisableableTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      // If the button is disabled, make onPressed null (Flutter treats it as disabled).
      onPressed: isDisabled ? null : onPressed,
      style: _buttonStyle(context),
      child: Text(label),
    );
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    return ButtonStyle(
      textStyle: WidgetStateProperty.all<TextStyle>(
        Theme.of(
          context,
        ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return Theme.of(context).disabledColor;
        }
        return Theme.of(context).textTheme.bodyLarge!.color!;
      }),
    );
  }
}
