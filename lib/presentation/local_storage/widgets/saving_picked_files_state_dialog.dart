import 'package:ellipsized_text/ellipsized_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hy_guard/business/local_storage_bloc/local_storage_bloc.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

class SavingPickedFilesStateDialog extends StatefulWidget {
  final int pickedFilesCount;
  final String currentFileName;

  const SavingPickedFilesStateDialog({
    super.key,
    required this.pickedFilesCount,
    required this.currentFileName,
  });

  @override
  State<SavingPickedFilesStateDialog> createState() =>
      _SavingPickedFilesStateDialogState();
}

class _SavingPickedFilesStateDialogState
    extends State<SavingPickedFilesStateDialog> {
  late final int _pickedFilesCount;
  late int _currentPickedFilesIndex;
  late String _currentFileName;

  @override
  void initState() {
    _pickedFilesCount = widget.pickedFilesCount;
    _currentFileName = widget.currentFileName;
    _currentPickedFilesIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocalStorageBloc, LocalStorageState>(
      listener: (context, state) {
        if (state is UpdateSavingPickedFilesState) {
          _currentPickedFilesIndex = state.currentPickedFilesIndex;
          _currentFileName = state.currentFileName;
        }
        if (state is CloseSavingPickedFilesState) {
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<LocalStorageBloc, LocalStorageState>(
        builder: (context, state) {
          return _buildSavingPickedFilesStateDialog();
        },
      ),
    );
  }

  Widget _buildSavingPickedFilesStateDialog() {
    return Dialog(
      alignment: Alignment.center,
      insetPadding: REdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: REdgeInsets.all(15),
        child: _buildDialogContent(),
      ),
    );
  }

  Widget _buildDialogContent() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),
            _buildProgressBar(constraints),
            SizedBox(height: 20.h),
            _buildFileDetailsRow(constraints),
            SizedBox(height: 20.h),
          ],
        );
      },
    );
  }

  Widget _buildProgressBar(BoxConstraints constraints) {
    double ratio = _pickedFilesCount == 0
        ? 0
        : _currentPickedFilesIndex / _pickedFilesCount;
    return SimpleAnimationProgressBar(
      height: 5,
      width: constraints.maxWidth,
      backgroundColor: Colors.black38,
      foregroundColor: Colors.purple,
      ratio: ratio,
      direction: Axis.horizontal,
      curve: Curves.fastLinearToSlowEaseIn,
      duration: const Duration(seconds: 3),
      borderRadius: BorderRadius.circular(10),
      gradientColor: const LinearGradient(
        colors: [Color(0xff7904fd), Color(0xffb61bef)],
      ),
    );
  }

  Widget _buildFileDetailsRow(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: EllipsizedText(
              _currentFileName,
              style: TextTheme.of(
                context,
              ).bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              type: EllipsisType.middle,
            ),
          ),
          SizedBox(width: 30.w),
          Text(
            "$_currentPickedFilesIndex / $_pickedFilesCount",
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
          ),
        ],
      ),
    );
  }
}
