import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class GlobalConfigService extends GetxService {
  final _storage = GetStorage();

  // 应用程序配置
  final appConfig = {
    'apiUrl': 'https://api.example.com',
    'appVersion': '1.0.0',
  }.obs;

  // 用户状态
  final userState = {
    'isLoggedIn': false,
    'userId': '',
    'username': '',
    'email': '',
  }.obs;

  // 用户偏好设置
  final userPreferences = {
    'isDarkMode': false,
    'language': 'en',
    'notificationsEnabled': true,
  }.obs;

  Future<GlobalConfigService> init() async {
    await loadConfigFromStorage();
    applyStoredSettings();
    return this;
  }

  Future<void> loadConfigFromStorage() async {
    final storedAppConfig = _storage.read('appConfig');
    if (storedAppConfig != null) {
      appConfig.value = Map<String, dynamic>.from(storedAppConfig);
    }

    final storedUserState = _storage.read('userState');
    if (storedUserState != null) {
      userState.value = Map<String, dynamic>.from(storedUserState);
    }

    final storedUserPreferences = _storage.read('userPreferences');
    if (storedUserPreferences != null) {
      userPreferences.value = Map<String, dynamic>.from(storedUserPreferences);
    }
  }

  void applyStoredSettings() {
    // 应用存储的主题设置
    Get.changeThemeMode(
        userPreferences['isDarkMode'] ? ThemeMode.dark : ThemeMode.light);

    // 应用存储的语言设置
    Get.updateLocale(Locale(userPreferences['language']));

    // 如果有其他需要在启动时应用的设置，可以在这里添加
  }

  void saveConfigToStorage() {
    _storage.write('appConfig', appConfig);
    _storage.write('userState', userState);
    _storage.write('userPreferences', userPreferences);
  }

  void updateAppConfig(Map<String, dynamic> newConfig) {
    appConfig.addAll(newConfig);
    saveConfigToStorage();
  }

  void updateUserState(Map<String, dynamic> newState) {
    userState.addAll(newState);
    saveConfigToStorage();
  }

  void updateUserPreferences(Map<String, dynamic> newPreferences) {
    userPreferences.addAll(newPreferences);
    saveConfigToStorage();
    applyStoredSettings();
  }

  void setDarkMode(bool isDarkMode) {
    userPreferences['isDarkMode'] = isDarkMode;
    saveConfigToStorage();
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  void setLanguage(String languageCode) {
    userPreferences['language'] = languageCode;
    saveConfigToStorage();
    Get.updateLocale(Locale(languageCode));
  }

  void login(String userId, String username, String email) {
    updateUserState({
      'isLoggedIn': true,
      'userId': userId,
      'username': username,
      'email': email,
    });
  }

  void logout() {
    updateUserState({
      'isLoggedIn': false,
      'userId': '',
      'username': '',
      'email': '',
    });
  }
}
