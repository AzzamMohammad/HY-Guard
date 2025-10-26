import 'package:hy_guard/core/constant/file_type.dart';

class RecentSearch {
  final String query;
  final FileType? filter;
  final int id;

  RecentSearch({required this.query, this.filter, required this.id});
}
