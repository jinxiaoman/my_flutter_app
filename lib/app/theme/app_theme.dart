import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTheme {
  static final light = ThemeData.light().copyWith(
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
    ),
  );

  static final dark = ThemeData.dark().copyWith(
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.grey[900],
  );
}

class ThemeService extends GetxService {
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
