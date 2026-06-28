import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'localization/app_locale.dart';
import 'screens/speech_screen.dart';
import 'screens/login_screen.dart';
import 'presentation/providers/auth_provider.dart';

class SpeakMateApp extends ConsumerWidget {
  const SpeakMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authProvider);

    return MaterialApp(
      title: AppLocale.strings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A1628),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00B8D4),
          surface: Color(0xFF0A1628),
        ),
        fontFamily: 'Roboto',
      ),
      home: isLoggedIn ? const SpeechScreen() : const LoginScreen(),
    );
  }
}
