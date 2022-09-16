import 'package:flutter/material.dart';
import '../common/styles.dart';
import '../data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {

  PreferencesHelper preferencesHelper;
  PreferencesProvider({required this.preferencesHelper}) {
    /// Metode ini di panggil di Constructor agar dipanggil pertama kali ketika objek provider dibuat.
    _getTheme();
    _getDailyNewsPreferences();
  }

  /// getter untuk mengembalikan nilai ThemeDataberdasarkan tema yang dipilih.
  ThemeData get themeData => _isDarkTheme ? darkTheme : lightTheme;

  /// Menambahkan getter supaya properti dapat diakses di luar kelas.
  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  bool _isDailyNewsActive = false;
  bool get isDailyNewsActive => _isDailyNewsActive;

  /// Method untuk mengakses metode yang telah di buat pada kelas helper
  void _getTheme() async {
    _isDarkTheme = await preferencesHelper.isDarkTheme;
    notifyListeners();
  }

  void _getDailyNewsPreferences() async {
    _isDailyNewsActive = await preferencesHelper.isDailyNewsActive;
    notifyListeners();
  }

  void enableDarkTheme(bool value) {
    preferencesHelper.setDarkTheme(value);
    _getTheme();
  }

  void enableDailyNews(bool value) {
    preferencesHelper.setDailyNews(value);
    _getDailyNewsPreferences();
  }
}