part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

final class SearchForContentEvent extends SearchEvent {
  final String query;
  final FileType? filter;

  SearchForContentEvent({required this.query, this.filter});
}

final class GetRecentSearchesEvent extends SearchEvent {}

final class SaveSearchToHistoryEvent extends SearchEvent {
  final String query;
  final FileType? filter;

  SaveSearchToHistoryEvent({required this.query, this.filter});
}

final class DeleteSearchFromHistoryEvent extends SearchEvent {
  final int id;

  DeleteSearchFromHistoryEvent({required this.id});
}

final class ClearRecentSearchesEvent extends SearchEvent {}

final class OpenFileEvent extends SearchEvent {
  final FolderContent file;

  OpenFileEvent({required this.file});
}
