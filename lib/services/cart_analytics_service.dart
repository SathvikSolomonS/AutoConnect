import 'package:shared_preferences/shared_preferences.dart';

class CartAnalyticsService {
  static Future<Map<String, int>> getAddedCarsStats() async {
    final prefs = await SharedPreferences.getInstance();
    final cart = prefs.getStringList('cart_cars') ?? [];

    final Map<String, int> counts = {};

    for (final car in cart) {
      counts[car] = (counts[car] ?? 0) + 1;
    }

    return counts;
  }
}
