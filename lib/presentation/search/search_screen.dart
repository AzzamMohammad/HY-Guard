import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hy_guard/business/search_bloc/search_bloc.dart';
import 'package:hy_guard/core/config/language/l10n/app_localization.dart';
import 'package:hy_guard/core/models/folder_content.dart';
import 'package:hy_guard/core/models/recent_search.dart';
import 'package:hy_guard/core/models/sub_folder.dart';
import 'package:hy_guard/core/utils/reference.dart';
import 'package:hy_guard/presentation/search/widgets/filters_content_bar.dart';
import 'package:hy_guard/presentation/search/widgets/recent_searches_bar.dart';
import 'package:hy_guard/presentation/search/widgets/search_content_bar.dart';
import 'package:hy_guard/presentation/widgets/folder_content_item.dart';

import '../../core/constant/file_type.dart';
import '../widgets/app_messenger.dart';
import '../widgets/content_details_dialog.dart';
import '../widgets/custom_back_Button.dart';

class SearchScreen extends StatefulWidget {
  final FileType? filter;

  const SearchScreen({super.key, this.filter});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchFieldController;
  late Reference<bool> _isFiltersBarOpen;
  late List<RecentSearch> _recentSearches;
  late Reference<FileType?> _filter;
  late List<FolderContent>? _searchResults;

  @override
  void initState() {
    _searchFieldController = TextEditingController();
    _isFiltersBarOpen = Reference(value: true);
    _filter = Reference(value: null);
    _searchResults = null;
    _recentSearches = [];
    _searchByInitFilter();
    _getRecentSearches();
    super.initState();
  }

  void _searchByInitFilter() {
    if (widget.filter != null) {
      _searchForQuery("", widget.filter);
    }
  }

  /// Requests the recent searches from the [SearchBloc]
  /// after the first frame is rendered.
  void _getRecentSearches() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<SearchBloc>(context).add(GetRecentSearchesEvent());
    });
  }

  @override
  void dispose() {
    _searchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      resizeToAvoidBottomInset: false,
      body: BlocListener<SearchBloc, SearchState>(
        listener: _listenToSearchStateChange,
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (BuildContext context, SearchState state) {
            return _buildSearchScreenContent();
          },
        ),
      ),
    );
  }

  void _listenToSearchStateChange(BuildContext context, SearchState state) {
    if (state is ReturnSearchResultsState) {
      _onReturnSearchResults(state);
    }
    if (state is ReturnRecentSearchesState) {
      _recentSearches = state.searches;
    }
    if (state is AnErrorHappenState) {
      _onAnErrorHappen();
    }
  }

  void _onAnErrorHappen() {
    AppMessenger().showError(
      context: context,
      message: AppLocalizations.of(context)!.an_error_happen,
    );
  }

  void _onReturnSearchResults(ReturnSearchResultsState state) {
    _searchResults = state.results;
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const CustomBackButton(),
      title: _buildSearchField(),
    );
  }

  Widget _buildSearchField() {
    return SearchContentBar(
      controller: _searchFieldController,
      onFiledContentChange: _searchForContent,
      onCleanTap: _cleanSearchFiledContent,
    );
  }

  Widget _buildSearchScreenContent() {
    return SafeArea(
      child: Padding(
        padding: REdgeInsets.all(8),
        child: Column(
          children: [
            _buildFiltersBar(),
            _searchResults == null
                ? _buildRecentSearchesBar()
                : _buildSearchResultsBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersBar() {
    return FiltersContentBar(
      isFiltersBarOpen: _isFiltersBarOpen,
      searchForContent: _searchForContent,
      searchQuery: _searchFieldController.text,
      filter: _filter,
    );
  }

  Widget _buildRecentSearchesBar() {
    if (_recentSearches.isEmpty) {
      return SizedBox.shrink();
    }
    return RecentSearchesBar(
      recentSearches: _recentSearches,
      onTapClearAll: _clearRecentSearches,
      onTapRecentSearchButton: (RecentSearch search) {
        _searchForQuery(search.query, search.filter);
      },
      onTapCancelRecentSearch: (RecentSearch search) {
        _deleteSearchFromStorage(search.id);
      },
    );
  }

  Widget _buildSearchResultsBar() {
    if (_searchResults!.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: .3.sh),
        child: Center(
          child: Text(AppLocalizations.of(context)!.no_results_found),
        ),
      );
    } else {
      return Expanded(
        child: Scrollbar(
          child: ListView.builder(
            itemCount: _searchResults!.length,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  _openFile(_searchResults![index]);
                },
                onLongPress: () {
                  _openDetails(_searchResults![index]);
                },
                child: FolderContentItem(folderContent: _searchResults![index]),
              );
            },
          ),
        ),
      );
    }
  }

  void _openFile(FolderContent file) {
    _saveSearchToHistory();
    if (file is SubFolder) return;
    context.read<SearchBloc>().add(OpenFileEvent(file: file));
  }

  void _openDetails(FolderContent content) async {
    _saveSearchToHistory();
    // close Keyboard
    FocusScope.of(context).unfocus();
    // await Keyboard to close
    await Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 50));
      if (!mounted) return false;
      return MediaQuery.of(context).viewInsets.bottom > 0;
    });
    if (!mounted) return;
    // open details
    showContentDetailsDialog(context, content);
  }

  void _searchForContent(String value) {
    final String query = value.trim();
    if (query.isNotEmpty || _filter.value != null) {
      _isFiltersBarOpen.value = false;
      context.read<SearchBloc>().add(
        SearchForContentEvent(query: query, filter: _filter.value),
      );
      setState(() {});
    } else {
      setState(() {
        _searchResults = null;
        _isFiltersBarOpen.value = true;
      });
    }
  }

  void _cleanSearchFiledContent() {
    setState(() {
      _searchFieldController.clear();
      _searchResults = null;
      _isFiltersBarOpen.value = true;
      _filter.value = null;
    });
  }

  void _saveSearchToHistory() {
    final query = _searchFieldController.text.trim();
    if (query.isNotEmpty) {
      context.read<SearchBloc>().add(
        SaveSearchToHistoryEvent(query: query, filter: _filter.value),
      );
    }
  }

  void _deleteSearchFromStorage(int id) {
    context.read<SearchBloc>().add(DeleteSearchFromHistoryEvent(id: id));
  }

  void _clearRecentSearches() {
    context.read<SearchBloc>().add(ClearRecentSearchesEvent());
  }

  void _searchForQuery(String query, FileType? filter) {
    _searchFieldController.text = query;
    _filter.value = filter;
    _searchForContent(query);
  }
}
