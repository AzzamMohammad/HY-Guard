import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/config/language/l10n/app_localization.dart';
import '../../../core/constant/assets_names.dart';

class EditToolBar extends StatelessWidget {
  final bool isEditModeOpen;
  final Function(GlobalKey?) onTapMove;
  final Function(GlobalKey?) onTapCopy;
  final Function(GlobalKey?) onTapShare;
  final Function(GlobalKey?) onTapDelete;
  final Function(GlobalKey?) onTapMore;
  final GlobalKey editToolButtonKey;

  const EditToolBar({
    super.key,
    required this.isEditModeOpen,
    required this.onTapMove,
    required this.onTapCopy,
    required this.onTapShare,
    required this.onTapDelete,
    required this.onTapMore,
    required this.editToolButtonKey,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 400),
      curve: Curves.linear,
      offset: isEditModeOpen ? const Offset(0, 0) : const Offset(0, 1),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isEditModeOpen ? 1 : 0,
        child: isEditModeOpen
            ? _buildEditToolBarContent(context)
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildEditToolBarContent(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildToolBarButton(
              context,
              AssetsNames.moveFolderContentIcon,
              AppLocalizations.of(context)!.move,
              onTapMove,
              null,
            ),
            _buildToolBarButton(
              context,
              AssetsNames.copyIcon,
              AppLocalizations.of(context)!.copy,
              onTapCopy,
              null,
            ),
            _buildToolBarButton(
              context,
              AssetsNames.shareIcon,
              AppLocalizations.of(context)!.share,
              onTapShare,
              null,
            ),
            _buildToolBarButton(
              context,
              AssetsNames.deleteIcon,
              AppLocalizations.of(context)!.delete,
              onTapDelete,
              null,
            ),
            _buildToolBarButton(
              context,
              AssetsNames.menuIcon,
              AppLocalizations.of(context)!.more,
              onTapMore,
              editToolButtonKey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolBarButton(
    BuildContext context,
    String iconPath,
    String label,
    Function(GlobalKey? key) onTap,
    GlobalKey? buttonKey,
  ) {
    return GestureDetector(
      key: buttonKey,
      onTap: () {
        onTap(buttonKey);
      },
      child: SizedBox(
        height: 50.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButtonIcon(iconPath, context),
            _buildButtonLabel(label, context),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonIcon(String iconPath, BuildContext context) {
    return Image.asset(
      iconPath,
      color: Theme.of(context).iconTheme.color,
      width: 20.r,
      height: 20.r,
    );
  }

  Widget _buildButtonLabel(String label, BuildContext context) {
    return Text(
      label,
      textScaler: TextScaler.noScaling,
      style: TextTheme.of(
        context,
      ).bodyMedium!.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
