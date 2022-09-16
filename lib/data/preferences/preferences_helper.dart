import 'package:shared_preferences/shared_preferences.dart';
/// Kelas ini membutuhkan objek SharedPreferences di dalamnya, maka tambahkan melalui constructor.
class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  /// untuk menyimpan key data yang ingin disimpan dalam shared preferences.
  static const DARK_THEME = 'DARK_THEME';
  /// untuk menyimpan pengaturan scheduling daily news.
  static const DAILY_NEWS = 'DAILY_NEWS';

  /// untuk membaca data dari shared preferences.
  Future<bool> get isDarkTheme async {
    final prefs = await sharedPreferences;
    return prefs.getBool(DARK_THEME) ?? false;
  }

  /// untuk menyimpan data dari shared preferences
  void setDarkTheme(bool value) async{
    final prefs = await sharedPreferences;
    prefs.setBool(DARK_THEME, value);
  }

  /// untuk menyimpan pengaturan scheduling daily news.
  Future<bool>get isDailyNewsActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(DAILY_NEWS) ?? false;
  }

  void setDailyNews(bool value) async{
    final prefs = await sharedPreferences;
    prefs.setBool(DAILY_NEWS, value);
  }
}