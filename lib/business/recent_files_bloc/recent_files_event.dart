part of 'recent_files_bloc.dart';

@immutable
sealed class RecentFilesEvent {}

final class GetRecentFilesEvent extends RecentFilesEvent {}

final class OpenRecentFileEvent extends RecentFilesEvent {
  final FolderContent file;

  OpenRecentFileEvent({required this.file});
}

final class ClearRecentFilesEvent extends RecentFilesEvent {}
