import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'hello': 'Hello',
          'settings': 'Settings',
        },
        'zh_CN': {
          'hello': '你好',
          'settings': '设置',
        },
      };
}
