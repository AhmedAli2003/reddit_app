import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/keys/shared_preferences_keys.dart';
import 'package:reddit_app/app/shared/providers/shared_providers.dart';
import 'package:reddit_app/app/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>(
  (ref) => ThemeNotifier(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  ),
);

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _mode;
  final SharedPreferences _sharedPreferences;

  ThemeNotifier({
    ThemeMode mode = ThemeMode.dark,
    required SharedPreferences sharedPreferences,
  })  : _sharedPreferences = sharedPreferences,
        _mode = mode,
        super(AppTheme.darkModeAppTheme) {
    getTheme();
  }

  ThemeMode get mode => _mode;

  void getTheme() async {
    final theme = _sharedPreferences.getString(SharedPreferencesKeys.theme);

    if (theme == SharedPreferencesKeys.light) {
      _mode = ThemeMode.light;
      state = AppTheme.lightModeAppTheme;
    } else {
      _mode = ThemeMode.dark;
      state = AppTheme.darkModeAppTheme;
    }
  }

  void toggleTheme() async {
    if (_mode == ThemeMode.dark) {
      _mode = ThemeMode.light;
      state = AppTheme.lightModeAppTheme;
      _sharedPreferences.setString(SharedPreferencesKeys.theme, SharedPreferencesKeys.light);
    } else {
      _mode = ThemeMode.dark;
      state = AppTheme.darkModeAppTheme;
      _sharedPreferences.setString(SharedPreferencesKeys.theme, SharedPreferencesKeys.dark);
    }
  }
}
