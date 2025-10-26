import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/config/language/l10n/app_localization.dart';
import '../../../core/constant/app_routes_names.dart';
import '../../../core/constant/assets_names.dart';
import '../../widgets/custom_divider.dart';

class StorageOptions extends StatelessWidget {
  const StorageOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppLocalizations.of(context)!.storage,
          style: TextTheme.of(
            context,
          ).titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        _buildLocalStorageButton(context),
        const CustomDivider(),
        _buildCloudButton(context),
      ],
    );
  }

  Widget _buildLocalStorageButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutesNames.localStorage);
      },
      child: _buildIconTitleTile(
        context,
        AssetsNames.localeStorageIcon,
        AppLocalizations.of(context)!.locale_storage,
        Theme.of(context).iconTheme.color,
        true,
      ),
    );
  }

  Widget _buildCloudButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {},
      child: _buildIconTitleTile(
        context,
        AssetsNames.cloudIcon,
        AppLocalizations.of(context)!.cloud,
        Theme.of(context).iconTheme.color,
        false,
      ),
    );
  }

  Widget _buildIconTitleTile(
    BuildContext context,
    String icon,
    String name,
    Color? color,
    bool isConnect,
  ) {
    return ListTile(
      leading: Image.asset(icon, width: 20.r, height: 20.r, color: color),
      title: Text(name, style: TextTheme.of(context).bodyLarge, maxLines: 1),
      trailing: _buildStorageState(context, isConnect),
    );
  }

  Widget _buildStorageState(BuildContext context, bool isConnect) {
    if (isConnect) {
      return SizedBox.shrink();
    } else {
      return _buildNotConnectedStorage(context);
    }
  }

  Widget _buildNotConnectedStorage(BuildContext context) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          AppLocalizations.of(context)!.not_connected,
          style: TextTheme.of(context).labelSmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
