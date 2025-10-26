import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hy_guard/data/storage/models/hive_models/hive_recent_search.dart';

import '../../core/constant/hive_boxes_names.dart';

class RecentSearchStorage {
  static final RecentSearchStorage _instance = RecentSearchStorage._internal();

  factory RecentSearchStorage() => _instance;

  RecentSearchStorage._internal();

  late Box<HiveRecentSearch> _recentSearchBox;
  bool _isOpen = false;

  Future<void> openBox() async {
    if (!_isOpen) {
      _recentSearchBox = await Hive.openBox<HiveRecentSearch>(
        HiveBoxesNames.recentSearch,
      );
      _isOpen = true;
    }
  }

  void putNewSearch(HiveRecentSearch search) => _recentSearchBox.add(search);

  Future<void> deleteSearch(int searchId) async =>
      await _recentSearchBox.delete(searchId);

  Map<dynamic, HiveRecentSearch> getRecentSearchesMap() =>
      _recentSearchBox.toMap();

  Future<void> clearRecentSearchStorage() async =>
      await _recentSearchBox.clear();
}
