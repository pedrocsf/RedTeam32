import 'package:app/l10n/app_localizations.dart';
import 'package:app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/connection_screen.dart';
import 'theme/cybersecurity_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final bool DEBUG_FORCE_CHAT_SCREEN = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: CybersecurityTheme.darkTheme,
      darkTheme: CybersecurityTheme.darkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      //pra força o idioma
      //locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      home: DEBUG_FORCE_CHAT_SCREEN ? ChatScreen() : const ConnectionScreen(),
    );
  }
}
