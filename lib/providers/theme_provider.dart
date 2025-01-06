import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShimmerColors extends ThemeExtension<ShimmerColors> {
  final Color baseColor;
  final Color highlightColor;

  ShimmerColors({required this.baseColor, required this.highlightColor});

  @override
  ShimmerColors copyWith({Color? baseColor, Color? highlightColor}) {
    return ShimmerColors(
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }

  @override
  ShimmerColors lerp(ThemeExtension<ShimmerColors>? other, double t) {
    if (other is! ShimmerColors) return this;
    return ShimmerColors(
      baseColor: Color.lerp(baseColor, other.baseColor, t)!,
      highlightColor: Color.lerp(highlightColor, other.highlightColor, t)!,
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  ThemeProvider() {
    _loadThemePreference();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData {
    return ThemeData(
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      primarySwatch: _isDarkMode ? Colors.green : Colors.lightGreen, // Darker green for light mode
      primaryColor: _isDarkMode ? Colors.green : Colors.lightGreen[700], // Darker green for light mode
      primaryColorLight: _isDarkMode ? Colors.green : Colors.lightGreen[200], // Darker green for light mode
      cardColor: _isDarkMode ? Colors.grey[800] : Colors.grey[100],
      dividerColor: _isDarkMode ? Colors.grey[700] : Colors.grey[300], // Darker divider color for dark mode
      scaffoldBackgroundColor: _isDarkMode ? Colors.black : Colors.white,
      textTheme: TextTheme(
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(fontSize: 17),
        bodyMedium: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
      ),
      iconTheme: IconThemeData(color: _isDarkMode ? Colors.white : Colors.black),
      extensions: [
        ShimmerColors(
          baseColor: _isDarkMode ? Colors.grey[700]! : Colors.grey[50]!,
          highlightColor: _isDarkMode ? Colors.grey[500]! : Colors.grey[200]!,
        ),
      ],
    );
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemePreference();
    notifyListeners();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }
}