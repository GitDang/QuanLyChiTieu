import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:base_project/utils/commons/shared_preference.dart';

class LocaleManager {
  LocaleManager._internal();

  static LocaleManager instance = LocaleManager._internal();

  late Locale locale;
  late Locale fallbackLocale;

  List<String> listLanguageCode = ['ja'];

  Future getCurrentLanguage() async {
    String? languageCode = await SharedPreferenceUtil.getLanguageCode();
    if (languageCode != null) {
      locale = Locale(languageCode);
    } else if (Get.deviceLocale != null && listLanguageCode.contains(Get.deviceLocale?.languageCode ?? "")) {
      locale = Get.deviceLocale!;
    } else {
      locale = Locale(listLanguageCode.first);
    }
    fallbackLocale = Locale(locale.languageCode);
    SharedPreferenceUtil.saveLanguageCode(locale.languageCode);
  }

  void setLanguage(String languageCode) {
    Get.updateLocale(Locale(languageCode));
    SharedPreferenceUtil.saveLanguageCode(languageCode);
  }
}
