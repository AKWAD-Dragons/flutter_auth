import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  ///// Singleton
  static SharedPreferencesProvider _spProvider;

  SharedPreferences prefs;
  String LOCALE = "LOCALE";

  static SharedPreferencesProvider instance() {
    if (_spProvider == null) {
      _spProvider = SharedPreferencesProvider._();
    }
    return _spProvider;
  }

  SharedPreferencesProvider._();

  Future<String> getLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(LOCALE);
  }

  Future<void> setLocale(String locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(LOCALE,locale);
  }
}
