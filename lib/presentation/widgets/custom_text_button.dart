import 'package:flutter/material.dart';

/// A custom text button with custom style
class CustomTextButton extends StatelessWidget {
  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// The text displayed inside the button.
  final String label;

  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      // If the button is disabled, make onPressed null (Flutter treats it as disabled).
      onPressed: onPressed,
      style: _buttonStyle(context),
      child: Text(label, maxLines: 2,textScaler: TextScaler.noScaling,),
    );
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    return ButtonStyle(
      textStyle: WidgetStateProperty.all<TextStyle>(
        Theme.of(
          context,
        ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        return Theme.of(context).textTheme.bodyLarge!.color!;
      }),
    );
  }
}
