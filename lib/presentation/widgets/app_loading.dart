import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// A utility class to show and hide a loading dialog.
/// This class uses `showDialog` internally to display a modal loading indicator.
class AppLoading {
  /// Shows the loading dialog.
  ///
  /// [context] is the BuildContext from which the dialog is displayed.
  void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Theme.of(context).primaryColor.withAlpha(2),
          elevation: 0,
          child: _buildLoadingIndicator(context),
        );
      },
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    const double deg45 = 45 * 3.1415926535 / 180;
    return Center(
      child: Transform.rotate(
        angle: deg45,
        child: Container(
          width: 70.r,
          height: 70.r,
          padding: REdgeInsets.all(17.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: Theme.of(context).primaryColorDark,
          ),
          child: _loadingAnimation(context, deg45),
        ),
      ),
    );
  }

  Widget _loadingAnimation(BuildContext context, double deg45) {
    return Transform.rotate(
      angle: -deg45,
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Theme.of(context).cardColor,
        size: 30.r,
      ),
    );
  }

  /// Hides the currently displayed loading dialog.
  ///
  /// [context] is the BuildContext used to locate the Navigator.
  void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
