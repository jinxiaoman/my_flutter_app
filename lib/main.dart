import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_flutter_app/app/routes/app_pages.dart';
import 'package:my_flutter_app/app/data/services/global_config_service.dart';
import 'package:my_flutter_app/app/translations/app_translations.dart';
import 'package:my_flutter_app/generated/locales.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Get.putAsync(() => GlobalConfigService().init());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final configService = Get.find<GlobalConfigService>();

    return GetMaterialApp(
      title: 'My App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: configService.userPreferences['isDarkMode'] != null
          ? ThemeMode.dark
          : ThemeMode.light,
      locale: Locale(configService.userPreferences['language']),
      translationsKeys: AppTranslation.translations,
      initialRoute:
          configService.userState['isLoggedIn'] != null ? '/home' : '/login',
      getPages: AppPages.routes,
    );
  }
}
