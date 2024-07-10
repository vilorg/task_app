import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _revisionKey = 'revision';

  static Future<int> getRevision() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_revisionKey) ?? 0;
  }

  static Future<void> setRevision(int revision) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_revisionKey, revision);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_revisionKey);
  }
}
