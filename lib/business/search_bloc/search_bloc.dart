import 'package:bloc/bloc.dart';
import 'package:hy_guard/core/constant/file_type.dart';
import 'package:hy_guard/core/models/folder_content.dart';
import 'package:hy_guard/core/models/recent_search.dart';
import 'package:hy_guard/core/utils/either.dart';
import 'package:hy_guard/data/repositories/local_storage_repository/local_storage_repository.dart';
import 'package:hy_guard/data/repositories/search_repository.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();
  final SearchRepository _searchRepository = SearchRepository();

  SearchBloc() : super(SearchInitial()) {
    on<SearchForContentEvent>(_onSearchForContent);
    on<GetRecentSearchesEvent>(_onGetRecentSearches);
    on<SaveSearchToHistoryEvent>(_onSaveSearchToHistory);
    on<DeleteSearchFromHistoryEvent>(_onDeleteSearchFromHistory);
    on<ClearRecentSearchesEvent>(_onClearRecentSearches);
    on<OpenFileEvent>(_onOpenFile);
  }

  void _onSearchForContent(
    SearchForContentEvent event,
    Emitter<SearchState> emit,
  ) async {
    List<FolderContent> results = [];
    bool isErrorHappen = false;
    // search in local storage
    Either<String, List<FolderContent>> searchResult =
        await _localStorageRepository.searchForContent(
          event.query,
          event.filter,
        );
    if (searchResult.isRight) {
      List<FolderContent> localeResults = searchResult.fold(
        (l) => [],
        (r) => r,
      );
      results.addAll(localeResults);
    } else {
      isErrorHappen = true;
    }
    // search in external storage
    //
    //
    emit(ReturnSearchResultsState(results: results));
    if (isErrorHappen) {
      emit(AnErrorHappenState());
    }
  }

  void _onGetRecentSearches(
    GetRecentSearchesEvent event,
    Emitter<SearchState> emit,
  ) async {
    List<RecentSearch> searches = await _searchRepository.getRecentSearches();
    emit(ReturnRecentSearchesState(searches: searches));
  }

  void _onSaveSearchToHistory(
    SaveSearchToHistoryEvent event,
    Emitter<SearchState> emit,
  ) async {
    List<RecentSearch> updatedSearches = await _searchRepository
        .saveSearchToHistory(event.query, event.filter);
    emit(ReturnRecentSearchesState(searches: updatedSearches));
  }

  void _onDeleteSearchFromHistory(
    DeleteSearchFromHistoryEvent event,
    Emitter<SearchState> emit,
  ) async {
    List<RecentSearch> updatedSearches = await _searchRepository
        .deleteSearchToHistory(event.id);
    emit(ReturnRecentSearchesState(searches: updatedSearches));
  }

  void _onClearRecentSearches(
    ClearRecentSearchesEvent event,
    Emitter<SearchState> emit,
  ) async {
    await _searchRepository.clearSearchHistory();
    emit(ReturnRecentSearchesState(searches: []));
  }

  void _onOpenFile(OpenFileEvent event, Emitter<SearchState> emit) {
    _searchRepository.addFileToRecentFiles(event.file.id);
    event.file.open();
  }
}
