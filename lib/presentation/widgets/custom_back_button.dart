import 'package:flutter/material.dart';

/// A customizable back button widget.
///
/// Pops (closes) the current route using `Navigator.pop()`.
///
/// You can provide a custom [icon]; if none is given, a default
/// `Icons.arrow_back_ios_sharp` icon is used.
class CustomBackButton extends StatelessWidget {
  final Widget? icon;

  const CustomBackButton({super.key, this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: icon ?? Icon(Icons.arrow_back_ios_sharp),
    );
  }
}
