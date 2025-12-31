import 'package:shared_preferences/shared_preferences.dart';

class LocalAnalyticsService {
  static Future<void> trackFavorite(String carName) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('fav_stats') ?? [];
    list.add(carName);
    await prefs.setStringList('fav_stats', list);
  }

  static Future<Map<String, int>> getFavoriteStats() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('fav_stats') ?? [];

    final Map<String, int> map = {};
    for (final car in list) {
      map[car] = (map[car] ?? 0) + 1;
    }
    return map;
  }
}
