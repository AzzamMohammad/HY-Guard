import 'package:flutter/material.dart';
import 'package:hy_guard/core/config/language/l10n/app_localization.dart';

import '../../widgets/custom_back_Button.dart';

AppBar defaultModeAppBar({
  required Function() createNewFolder,
  required Function() onTapSearch,
  required Function() pickFile,
}) {
  return AppBar(
    leading: const CustomBackButton(),
    actions: [
      _buildSearchButton(onTapSearch),
      _buildAddNewFolderButton(createNewFolder, pickFile),
    ],
  );
}

Widget _buildSearchButton(Function() onTapSearch) {
  return IconButton(onPressed: onTapSearch, icon: Icon(Icons.search));
}

Widget _buildAddNewFolderButton(
  Function() createNewFolder,
  Function() pickFile,
) {
  return PopupMenuButton<String>(
    itemBuilder: (context) {
      return [
        PopupMenuItem<String>(
          onTap: createNewFolder,
          child: Text(AppLocalizations.of(context)!.create_folder),
        ),
        PopupMenuItem<String>(
          onTap: pickFile,
          child: Text(AppLocalizations.of(context)!.add_file),
        ),
      ];
    },
  );
}
