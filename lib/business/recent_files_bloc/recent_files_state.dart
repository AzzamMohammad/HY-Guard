part of 'recent_files_bloc.dart';

@immutable
sealed class RecentFilesState {}

final class RecentFilesInitial extends RecentFilesState {}

final class ReturnRecentFiles extends RecentFilesState {
  final List<FolderContent> recentContents;

  ReturnRecentFiles({required this.recentContents});
}

final class AnErrorHappenState extends RecentFilesState {
  final String? errorMessage;

  AnErrorHappenState({this.errorMessage});
}

final class RecentFilesClearedSuccessfully extends RecentFilesState {}
