import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A widget that displays auth method icon
class AuthMethodIcon extends StatelessWidget {
  final String iconPath;
  final void Function()? onPressed;

  const AuthMethodIcon({super.key, required this.iconPath, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Image.asset(
        iconPath,
        fit: BoxFit.contain,
        color: Theme.of(context).iconTheme.color,
        width: 30.r,
        height: 30.r,
      ),
    );
  }
}
