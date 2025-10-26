import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../../../core/constant/file_type.dart';

part 'hive_recent_search.g.dart';

@HiveType(typeId: 4)
class HiveRecentSearch {
  @HiveField(0)
  final String query;

  @HiveField(1)
  final FileType? filter;

  HiveRecentSearch({required this.query, this.filter});

  HiveRecentSearch copyWith({String? query, FileType? filter}) {
    return HiveRecentSearch(
      query: query ?? this.query,
      filter: filter ?? this.filter,
    );
  }
}
