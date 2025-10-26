import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hy_guard/core/constant/app_routes_names.dart';
import 'package:hy_guard/core/models/folder_content.dart';

import '../../business/recent_files_bloc/recent_files_bloc.dart';
import '../../core/config/language/l10n/app_localization.dart';
import '../widgets/app_messenger.dart';
import '../widgets/content_details_dialog.dart';
import '../widgets/custom_back_Button.dart';
import '../widgets/folder_content_item.dart';

class RecentFilesScreen extends StatefulWidget {
  const RecentFilesScreen({super.key});

  @override
  State<RecentFilesScreen> createState() => _RecentFilesScreenState();
}

class _RecentFilesScreenState extends State<RecentFilesScreen> {
  late List<FolderContent> _recentFiles;

  @override
  void initState() {
    _recentFiles = [];
    _getRecentFiles();
    super.initState();
  }

  void _getRecentFiles() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<RecentFilesBloc>(context).add(GetRecentFilesEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocListener<RecentFilesBloc, RecentFilesState>(
        listener: _listenToRecentFilesStateChange,
        child: BlocBuilder<RecentFilesBloc, RecentFilesState>(
          builder: (BuildContext context, RecentFilesState state) {
            return _recentFiles.isNotEmpty
                ? _buildRecentFilesList()
                : _buildNoElements();
          },
        ),
      ),
    );
  }

  void _listenToRecentFilesStateChange(
    BuildContext context,
    RecentFilesState state,
  ) {
    if (state is ReturnRecentFiles) {
      _recentFiles = state.recentContents;
    }
    if (state is RecentFilesClearedSuccessfully) {
      _recentFiles = [];
      AppMessenger().showSuccess(
        context: context,
        message: AppLocalizations.of(
          context,
        )!.recent_files_list_cleared_successfully,
      );
    }
    if (state is AnErrorHappenState) {
      AppMessenger().showError(
        context: context,
        message:
            state.errorMessage ?? AppLocalizations.of(context)!.an_error_happen,
      );
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: CustomBackButton(),
      actions: [_buildSearchIcon(), _buildMenu()],
    );
  }

  Widget _buildSearchIcon() {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(AppRoutesNames.search);
      },
      icon: Icon(Icons.search),
    );
  }

  Widget _buildMenu() {
    return PopupMenuButton<String>(
      itemBuilder: (context) {
        return [
          PopupMenuItem<String>(
            onTap: _onClearRecentFilesTap,
            child: Text(AppLocalizations.of(context)!.clear_recent_files_list),
          ),
        ];
      },
    );
  }

  Widget _buildRecentFilesList() {
    return ListView.builder(
      itemCount: _recentFiles.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _openFile(_recentFiles[index]);
          },
          onLongPress: () {
            _openDetails(_recentFiles[index]);
          },
          child: FolderContentItem(folderContent: _recentFiles[index]),
        );
      },
    );
  }

  Widget _buildNoElements() {
    return Center(child: Text(AppLocalizations.of(context)!.no_results_found));
  }

  void _onClearRecentFilesTap() {
    context.read<RecentFilesBloc>().add(ClearRecentFilesEvent());
  }

  void _openFile(FolderContent file) {
    context.read<RecentFilesBloc>().add(OpenRecentFileEvent(file: file));
  }

  void _openDetails(FolderContent content) async {
    showContentDetailsDialog(context, content);
  }
}
