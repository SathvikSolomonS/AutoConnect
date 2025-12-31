import 'package:shared_preferences/shared_preferences.dart';

class SearchAnalyticsService {
  static const _key = 'search_stats';

  /// SAVE search when user clicks a car
  static Future<void> logSearch(String carName) async {
    final prefs = await SharedPreferences.getInstance();
    final map = prefs.getStringList(_key) ?? [];

    // store as "carName|count"
    final Map<String, int> stats = {};

    for (final item in map) {
      final parts = item.split('|');
      stats[parts[0]] = int.parse(parts[1]);
    }

    stats[carName] = (stats[carName] ?? 0) + 1;

    final updated = stats.entries
        .map((e) => '${e.key}|${e.value}')
        .toList();

    await prefs.setStringList(_key, updated);
  }

  /// READ stats for admin (sorted DESC)
  static Future<Map<String, int>> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    final map = prefs.getStringList(_key) ?? [];

    final Map<String, int> stats = {};

    for (final item in map) {
      final parts = item.split('|');
      stats[parts[0]] = int.parse(parts[1]);
    }

    final sorted = stats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sorted);
  }
}
