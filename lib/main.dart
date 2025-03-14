import 'package:attendance_appschool/features/authentication/chose_page_login.dart';
import 'package:attendance_appschool/generated/l10n.dart';
import 'package:attendance_appschool/provider/AuthenticationProvider.dart';
import 'package:attendance_appschool/provider/localization_provider.dart';
import 'package:attendance_appschool/provider/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'data/sqflite/DBHelper.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthenticationProvider(DBHelper()),
        ),
        ChangeNotifierProvider(create: (ctx) => LocalizationProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        Provider<DBHelper>(
          create: (_) => DBHelper(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // locale: const Locale('fr'),
      locale: localizationProvider.currentLocale,
      title: 'ESTK-DIGITAL',
        home: const  ChosePageLogin(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: localizationProvider.supportedLocales,
    );
  }
}
