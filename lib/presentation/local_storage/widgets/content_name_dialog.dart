import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hy_guard/core/models/folder_content.dart';
import 'package:hy_guard/presentation/widgets/disableable_text_button.dart';
import '../../../core/config/language/l10n/app_localization.dart';
import '../../../core/models/sub_folder.dart';
import '../../widgets/custom_text_button.dart';

/// A dialog widget that allows the user to edit content name
class ContentNameDialog extends StatefulWidget {
  final List<FolderContent> contents;
  final String dialogTitle;
  final String returnNameButtonLabel;
  final String? defaultContentName;

  const ContentNameDialog({
    super.key,
    required this.contents,
    required this.dialogTitle,
    required this.returnNameButtonLabel,
    this.defaultContentName,
  });

  @override
  State<ContentNameDialog> createState() => _ContentNameDialogState();
}

class _ContentNameDialogState extends State<ContentNameDialog> {
  late final TextEditingController _nameTextFiledController;
  late String? _errorNameMessage;
  late String _dialogTitle;
  late String _returnNameButtonLabel;

  @override
  void initState() {
    super.initState();
    _errorNameMessage = null;
    _nameTextFiledController = TextEditingController(text: "folder");
    _dialogTitle = widget.dialogTitle;
    _returnNameButtonLabel = widget.returnNameButtonLabel;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // generate default name debend on contents names in selected folder
      _nameTextFiledController.text =
          widget.defaultContentName ?? _generateDefaultContentName();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameTextFiledController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: REdgeInsets.all(20),
      child: _buildDialogContent(),
    );
  }

  Widget _buildDialogContent() {
    return Container(
      width: 1.sw,
      padding: REdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDialogTitle(),
          _buildDialogTextField(),
          SizedBox(height: 10.h),
          _buildDialogActions(),
        ],
      ),
    );
  }

  Widget _buildDialogTitle() {
    return Text(
      _dialogTitle,
      style: TextTheme.of(
        context,
      ).bodyMedium!.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDialogTextField() {
    return TextFormField(
      autofocus: true,
      maxLines: 1,
      controller: _nameTextFiledController,
      decoration: InputDecoration(
        filled: false,
        errorText: _errorNameMessage,
        errorMaxLines: 2,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSurface,
            width: 2,
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
      ),
      onChanged: (value) {
        if (_folderNameIsExist(value)) {
          setState(() {
            _errorNameMessage = AppLocalizations.of(
              context,
            )!.folder_name_already_in_use;
          });
        } else if (_folderNaneValidator(value) != null) {
          setState(() {
            _errorNameMessage = _folderNaneValidator(value);
          });
        } else {
          setState(() {
            _errorNameMessage = null;
          });
        }
      },
    );
  }

  Widget _buildDialogActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCancelCreatingFolderButton(),
        SizedBox(height: 15, child: VerticalDivider()),
        _buildReturnNameButton(),
      ],
    );
  }

  Widget _buildReturnNameButton() {
    return DisableableTextButton(
      isDisabled:
          _errorNameMessage != null || _nameTextFiledController.text == "",
      label: _returnNameButtonLabel,
      onPressed: () {
        Navigator.of(context).pop(_nameTextFiledController.text.trim());
      },
    );
  }

  Widget _buildCancelCreatingFolderButton() {
    return CustomTextButton(
      label: AppLocalizations.of(context)!.cancel,
      onPressed: _cancelFolderCreation,
    );
  }

  void _cancelFolderCreation() {
    Navigator.pop(context, null);
  }

  /// generate default folder name debend on Folders names in selected folder
  String _generateDefaultContentName() {
    int counter = 1;
    String folderName = "${AppLocalizations.of(context)!.folder} $counter";
    while (_folderNameIsExist(folderName)) {
      counter++;
      folderName = "${AppLocalizations.of(context)!.folder} $counter";
    }
    return folderName;
  }

  // Checks if folder name already exists in the contents list
  bool _folderNameIsExist(String folderName) {
    for (FolderContent content in widget.contents) {
      if (content.name.toLowerCase() == folderName.toLowerCase() &&
          content is SubFolder) {
        return true;
      }
    }
    return false;
  }

  /// Validates a folder name based on common OS naming rules.
  /// Returns a validation message if invalid, or `null` if valid.
  String? _folderNaneValidator(String name) {
    final invalidChars = RegExp(r'[<>:"/\\|?*\x00-\x1F]');
    // Check if empty or whitespace only
    if (name.trim().isEmpty) {
      return AppLocalizations.of(
            context,
          )!.folder_name_cannot_be_empty_or_only_whitespace +
          AppLocalizations.of(
            context,
          )!.folder_name_cannot_be_empty_or_only_whitespace;
    }
    // Check if starts with a dot (hidden folder on Unix-like systems)
    if (name.startsWith('.')) {
      return AppLocalizations.of(context)!.folder_name_cannot_start_with_a_dot;
    }
    // Check for invalid characters used in most operating systems
    if (invalidChars.hasMatch(name)) {
      return AppLocalizations.of(
        context,
      )!.folder_name_contains_invalid_characters;
    }
    // Check maximum length (to avoid filesystem limits)
    if (name.length > 128) {
      return AppLocalizations.of(context)!.folder_name_is_too_long;
    }
    return null;
  }
}

Future<String?> showContentNameDialog({
  required BuildContext context,
  required List<FolderContent> contents,
  required String dialogTitle,
  required String returnNameButtonLabel,
  String? defaultContentName,
}) async {
  String? contentName = await showDialog<String>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black12,
    builder: (contexts) {
      return ContentNameDialog(
        contents: contents,
        dialogTitle: dialogTitle,
        returnNameButtonLabel: returnNameButtonLabel,
        defaultContentName: defaultContentName,
      );
    },
  );
  return contentName;
}
