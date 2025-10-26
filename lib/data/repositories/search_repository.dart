import 'package:hy_guard/core/constant/file_type.dart';
import 'package:hy_guard/core/constant/storage_type.dart';
import 'package:hy_guard/core/models/recent_search.dart';
import 'package:hy_guard/data/storage/models/hive_models/hive_recent_file.dart';
import 'package:hy_guard/data/storage/recent_file_storage.dart';
import 'package:hy_guard/data/storage/resent_search_storage.dart';

import '../storage/models/hive_models/hive_recent_search.dart';

class SearchRepository {
  late final RecentSearchStorage _recentSearchStorage;

  SearchRepository() {
    _recentSearchStorage = RecentSearchStorage();
  }

  Future<List<RecentSearch>> getRecentSearches() async {
    try {
      await _recentSearchStorage.openBox();
      Map<dynamic, HiveRecentSearch> recentSearches = _recentSearchStorage
          .getRecentSearchesMap();
      List<RecentSearch> searches = [];
      recentSearches.forEach((key, value) {
        searches.add(
          RecentSearch(query: value.query, filter: value.filter, id: key),
        );
      });
      return searches;
    } catch (error) {
      return [];
    }
  }

  Future<List<RecentSearch>> saveSearchToHistory(
    String query,
    FileType? filter,
  ) async {
    try {
      await _addSearchToStorage(query, filter);
      List<RecentSearch> searches = await getRecentSearches();
      return searches;
    } catch (error) {
      return [];
    }
  }

  /// Adds a new search query to local storage.
  ///
  /// - If a search with the same query already exists, it is removed first.
  /// - Keeps a maximum of 10 recent searches (removes the oldest if exceeded).
  Future<void> _addSearchToStorage(String query, FileType? filter) async {
    const maxSearches = 10;
    // get all stored searches
    final recentSearches = _recentSearchStorage.getRecentSearchesMap();
    for (final entry in recentSearches.entries) {
      // if there is stored search with seam query --> delete the stored copy
      if (query == entry.value.query) {
        await _recentSearchStorage.deleteSearch(entry.key);
        break;
      }
    }
    // Add the new search
    _recentSearchStorage.putNewSearch(
      HiveRecentSearch(query: query, filter: filter),
    );
    // Get updated list and enforce limit
    final updatedSearches = _recentSearchStorage.getRecentSearchesMap();
    if (updatedSearches.length > maxSearches) {
      await _recentSearchStorage.deleteSearch(updatedSearches.keys.first);
    }
  }

  Future<List<RecentSearch>> deleteSearchToHistory(int id) async {
    try {
      await _recentSearchStorage.deleteSearch(id);
      List<RecentSearch> searches = await getRecentSearches();
      return searches;
    } catch (error) {
      return [];
    }
  }

  Future<void> clearSearchHistory() async {
    try {
      await _recentSearchStorage.clearRecentSearchStorage();
    } catch (error) {}
  }

  void addFileToRecentFiles(String fileId) async {
    try {
      RecentFileStorage recentFileStorage = RecentFileStorage();
      await recentFileStorage.openBox();
      final recentFiles = recentFileStorage.getRecentFilesMap();
      for (var file in recentFiles.values) {
        if(file.fileId == fileId) {
          return;
        }
      }
      recentFileStorage.putNewFile(
        HiveRecentFile(
          fileId: fileId,
          storageType: StorageType.locale,
          lastModified: DateTime.now(),
        ),
      );
    } catch (error) {}
  }
}
