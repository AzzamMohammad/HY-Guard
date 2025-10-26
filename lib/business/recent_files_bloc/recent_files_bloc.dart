import 'package:bloc/bloc.dart';
import 'package:hy_guard/core/models/folder_content.dart';
import 'package:hy_guard/data/repositories/local_storage_repository/local_storage_repository.dart';
import 'package:meta/meta.dart';

import '../../core/constant/storage_type.dart';
import '../../core/models/recent_file.dart';
import '../../core/utils/either.dart';
import '../../data/repositories/recent_file_repository.dart';

part 'recent_files_event.dart';

part 'recent_files_state.dart';

class RecentFilesBloc extends Bloc<RecentFilesEvent, RecentFilesState> {
  final RecentFileRepository _recentFileRepository = RecentFileRepository();
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  RecentFilesBloc() : super(RecentFilesInitial()) {
    on<GetRecentFilesEvent>(_onGetRecentFiles);
    on<OpenRecentFileEvent>(_onOpenRecentFile);
    on<ClearRecentFilesEvent>(_onClearRecentFiles);
  }

  void _onGetRecentFiles(
    GetRecentFilesEvent event,
    Emitter<RecentFilesState> emit,
  ) async {
    final result = await _recentFileRepository.getRecentFiles();
    if (result.isRight) {
      List<RecentFile> recentFiles = result.fold((l) => [], (r) => r);
      // Separate files into local and cloud storage
      final localeFiles = recentFiles
          .where((f) => f.storageType == StorageType.locale)
          .toList();
      final cloudFiles = recentFiles
          .where((f) => f.storageType == StorageType.cloud)
          .toList();

      final List<FolderContent> recentContent = [];

      // Process local files
      if (localeFiles.isNotEmpty) {
        final localContent = await _getLocaleRecentContents(localeFiles);
        recentContent.addAll(localContent);

      }
      if (cloudFiles.isNotEmpty) {
        // Implement cloud storage handling here
      }

      // Emit the final state with all recent contents
      emit(ReturnRecentFiles(recentContents: recentContent.reversed.toList()));
    }
  }

  Future<List<FolderContent>> _getLocaleRecentContents(List<RecentFile> localeFiles)async {
    // Extract all file IDs
    final contentIds = localeFiles.map((file) => file.id).toList();
    final result = await _localStorageRepository.recentFileToContent(contentIds);

    return result.fold((error) {
      // Log the error and return an empty list
      return <FolderContent>[];
    }, (localContent) => localContent);
  }

  void _onOpenRecentFile(
    OpenRecentFileEvent event,
    Emitter<RecentFilesState> emit,
  ) {
    event.file.open();
  }

  void _onClearRecentFiles(
    ClearRecentFilesEvent event,
    Emitter<RecentFilesState> emit,
  ) async {
    Either<String, bool> result = await _recentFileRepository
        .clearRecentFilesList();
    if (result.isRight) {
      emit(RecentFilesClearedSuccessfully());
    } else {
      emit(AnErrorHappenState());
    }
  }
}
