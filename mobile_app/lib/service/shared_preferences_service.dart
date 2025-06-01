import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static final Future<SharedPreferences> _prefsInstance =
      SharedPreferences.getInstance();

  static Future<void> saveAuthTokenToPrefs(String token) async {
    _prefsInstance.then((SharedPreferences prefs) {
      prefs.setString("authToken", token);
    });
  }

  static Future<void> saveRefreshTokenToPrefs(String token) async {
    _prefsInstance.then((SharedPreferences prefs) {
      prefs.setString("refreshToken", token);
    });
  }

  static Future<String> getAuthTokenFromPrefs() async {
    _prefsInstance.then((SharedPreferences prefs) {
      return prefs.getString("authToken");
    });
    return '';
  }

  static Future<String> getRefreshTokenFromPrefs() async {
    _prefsInstance.then((SharedPreferences prefs) {
      return prefs.getString("refreshToken");
    });
    return '';
  }
}
