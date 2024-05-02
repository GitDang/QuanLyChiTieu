import 'package:shared_preferences/shared_preferences.dart';

class _SharedPreferenceKey {
  static const String languageCode = 'languageCode';
  static const String moneyFirst = 'moneyFirst';
}

class SharedPreferenceUtil {
  static Future saveLanguageCode(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_SharedPreferenceKey.languageCode, code);
  }

  static Future<String?> getLanguageCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_SharedPreferenceKey.languageCode);
  }

  static Future saveMoneyFirst(bool money) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_SharedPreferenceKey.moneyFirst, money);
  }

  static Future<bool?> getMoneyFirst() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_SharedPreferenceKey.moneyFirst);
  }

  static Future clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
