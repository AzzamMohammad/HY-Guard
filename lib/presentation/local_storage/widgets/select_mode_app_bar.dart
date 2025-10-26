import 'package:flutter/material.dart';

import '../../../core/config/language/l10n/app_localization.dart';

AppBar selectModeAppBar({
  required BuildContext context,
  required int selectedItemsNumber,
  required int allItemsNumber,
  required Function(bool) onSelectAll,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    leading: _buildSelectAll(
      context,
      selectedItemsNumber,
      allItemsNumber,
      onSelectAll,
    ),
    title: _buildSelectedCounterText(context, selectedItemsNumber),
  );
}

Widget _buildSelectAll(
  BuildContext context,
  int selectedItemsNumber,
  int allItemsNumber,
  Function(bool) onSelectAll,
) {
  bool isSelectedAll = selectedItemsNumber == allItemsNumber;
  return GestureDetector(
    onTap: () {
      onSelectAll(!isSelectedAll);
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: isSelectedAll,
            onChanged: (value) {
              onSelectAll(value!);
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: CircleBorder(),
          ),
        ),
        Text(
          AppLocalizations.of(context)!.all,
          style: TextTheme.of(context).bodyMedium,
        ),
      ],
    ),
  );
}

Widget _buildSelectedCounterText(
  BuildContext context,
  int selectedItemsNumber,
) {
  return Text("$selectedItemsNumber ${AppLocalizations.of(context)!.selected}");
}
