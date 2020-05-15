import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtil {
  static SharedPreferences prefs;

  static Future<void> setup() async {
    prefs = await SharedPreferences.getInstance();
  }

  static void removePreferences(String key) {
    prefs.remove(key);
  }

  static void setPreferences(String key, String data) {
    prefs.setString(key, data);
  }

  static String getPreferences(String key) {
    if (prefs.getString(key) == null) {
      return "";
    }
    return prefs.getString(key);
  }

  static void setListPreferences(String key, List<String> data) {
    prefs.setStringList(key, data);
  }

  static List<String> getListPreferences(String key) {
    if (prefs.getString(key) == null) {
      return [];
    }
    return prefs.getStringList(key);
  }
}
