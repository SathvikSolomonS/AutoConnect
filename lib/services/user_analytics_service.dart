import 'package:shared_preferences/shared_preferences.dart';

class UserAnalyticsService {
  static Future<int> getTotalUsers() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('total_users') ?? 0;
  }
}
