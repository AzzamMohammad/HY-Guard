import 'package:flutter/material.dart';
import 'package:hy_guard/core/models/recent_search.dart';

import '../../../core/config/language/l10n/app_localization.dart';

class RecentSearchesBar extends StatelessWidget {
  final List<RecentSearch> recentSearches;
  final Function() onTapClearAll;
  final Function(RecentSearch) onTapRecentSearchButton;
  final Function(RecentSearch) onTapCancelRecentSearch;

  const RecentSearchesBar({
    super.key,
    required this.recentSearches,
    required this.onTapClearAll,
    required this.onTapRecentSearchButton,
    required this.onTapCancelRecentSearch,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecentSearchesTitle(context),
          _buildRecentSearches(context),
        ],
      ),
    );
  }

  Widget _buildRecentSearchesTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.recent_searches,
          style: TextTheme.of(context).titleLarge,
        ),
        TextButton(
          onPressed: onTapClearAll,
          style: _buttonStyle(context),
          child: Text(AppLocalizations.of(context)!.clear_all),
        ),
      ],
    );
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    return ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        return Theme.of(context).textTheme.bodyMedium!.color!;
      }),
      iconColor: WidgetStateProperty.resolveWith<Color>((states) {
        return Theme.of(context).textTheme.bodyMedium!.color!;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
        return Colors.transparent;
      }),
    );
  }

  Widget _buildRecentSearches(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 8,
      children: recentSearches.reversed.map((search) {
        return _recentSearchButton(search, context);
      }).toList(),
    );
  }

  Widget _recentSearchButton(RecentSearch search, BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: () {
        onTapRecentSearchButton(search);
      },
      label: Text(search.query),
      iconAlignment: IconAlignment.end,
      icon: GestureDetector(
        onTap: () {
          onTapCancelRecentSearch(search);
        },
        child: Icon(Icons.close),
      ),
      style: _buttonStyle(context),
    );
  }
}
