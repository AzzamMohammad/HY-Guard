part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class AnErrorHappenState extends SearchState {
  final String? errorMessage;

  AnErrorHappenState({this.errorMessage});
}

final class ReturnRecentSearchesState extends SearchState {
  final List<RecentSearch> searches;

  ReturnRecentSearchesState({required this.searches});
}

final class ReturnSearchResultsState extends SearchState {
  final List<FolderContent> results;

  ReturnSearchResultsState({required this.results});
}
