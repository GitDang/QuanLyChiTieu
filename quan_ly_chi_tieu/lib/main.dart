import 'package:base_project/screens/screens.dart';
import 'package:base_project/resources/messages.dart';
import 'package:base_project/utils/databases/database_manager.dart';
import 'package:base_project/utils/language/locale_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleManager.instance.getCurrentLanguage();
  await DatabaseManager.instance.setupDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: GlobalLoaderOverlay(
        useDefaultLoading: true,
        overlayColor: Colors.white,
        overlayOpacity: 0.35,
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Inter'),
          translations: Messages(),
          locale: LocaleManager.instance.locale,
          fallbackLocale: LocaleManager.instance.fallbackLocale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ja', 'JA'),
          ],
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
